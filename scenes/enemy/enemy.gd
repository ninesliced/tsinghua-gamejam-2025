extends CharacterBody2D

class_name Enemy

@export var speed: float = 20

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var _agent: NavigationAgent2D = %NavigationAgent

@onready var health_component: HealthComponent = %HealthComponent
@onready var time_loss_indicator: Label = %TimeLossIndicator

var knockback: Vector2 = Vector2.ZERO
var can_be_knockback: bool = true
var knockback_iframe_time: float = 0.5

enum state {
	ATTACK,
	ELECTROCUTED,
}

var current_state: state = state.ATTACK

func _ready() -> void:
	make_path()
	SignalBus.on_enemy_created.emit(self)

func _physics_process(delta: float) -> void:
	if knockback_iframe_time > 0 and can_be_knockback == false:
		knockback_iframe_time -= delta
	else:
		knockback = Vector2.ZERO
		can_be_knockback = true
		knockback_iframe_time = 0.5
	match current_state:
		state.ATTACK:
			process_attacked_state(delta)
		state.ELECTROCUTED:
			pass

func make_path() -> void:
	if !GameGlobal.train:
		return
	_agent.target_position = GameGlobal.train.global_position


func _on_timer_timeout() -> void:
	make_path()

func _on_health_component_on_dead() -> void:
	set_electrocuted_state()
	
func apply_knockback(direction: Vector2, force: float) -> void:
	knockback = direction * force
	if can_be_knockback:
		velocity = knockback

		can_be_knockback = false
	
func _on_health_component_on_damage(amount: int) -> void:
	$AnimationPlayer.play("new_animation")
	Audio.hit.play()

	

func _on_navigation_agent_target_reached() -> void:
	if !state.ATTACK == current_state:
		return

	GameGlobal.game.time_left -= 5
	
	var offset := Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var rotation := randf_range(-0.2, 0.2)
	
	time_loss_indicator.visible = true
	time_loss_indicator.text = "-5s"
	time_loss_indicator.position = offset
	time_loss_indicator.rotation = rotation
	
	var tween := create_tween()
	tween.tween_property(time_loss_indicator, "position:y", offset.y - 20, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(time_loss_indicator, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", queue_free)


func process_attacked_state(delta: float) -> void:
	var next_path_position: Vector2 = _agent.get_next_path_position()
	velocity = velocity.move_toward(global_position.direction_to(next_path_position) * speed, delta * speed)
	if velocity.x != 0:
		animated_sprite_2d.flip_h = velocity.x > 0
	move_and_slide()
	pass

func set_electrocuted_state() -> void:
	current_state = state.ELECTROCUTED
	animated_sprite_2d.animation = "electrocuted"
	animated_sprite_2d.play()
	# await animated_sprite_2d.animation_finished
	await get_tree().create_timer(0.5).timeout
	queue_free()
