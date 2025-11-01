extends CharacterBody2D

class_name Enemy

@export var speed: float = 20

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var _agent: NavigationAgent2D = %NavigationAgent

@onready var health_component: HealthComponent = %HealthComponent

enum state {
	ATTACK,
	ELECTROCUTED,
}

var current_state: state = state.ATTACK

func _ready() -> void:
	make_path()
	SignalBus.on_enemy_created.emit(self)

func _physics_process(delta: float) -> void:
	match current_state:
		state.ATTACK:
			process_attacked_state(delta)
		state.ELECTROCUTED:
			pass

func make_path() -> void:
	_agent.target_position = GameGlobal.train.global_position


func _on_timer_timeout() -> void:
	make_path()

func _on_health_component_on_dead() -> void:
	set_electrocuted_state()

func _on_navigation_agent_target_reached() -> void:
	if !state.ATTACK == current_state:
		return
	GameGlobal.train.health_component.damage(1)
	queue_free()


func process_attacked_state(delta: float) -> void:
	var next_path_position: Vector2 = _agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * speed
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