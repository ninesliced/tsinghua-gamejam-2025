extends CharacterBody2D

class_name Enemy

@export var speed: float = 20
@export var target: Node2D

@onready var _agent: NavigationAgent2D = %NavigationAgent

@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	make_path()

func _physics_process(delta: float) -> void:
	if not target:
		return

	var next_path_position: Vector2 = _agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * speed
	move_and_slide()

func make_path() -> void:
	if target:
		_agent.target_position = target.global_position


func _on_timer_timeout() -> void:
	make_path()

func _on_health_component_on_dead() -> void:
	queue_free()

func _on_navigation_agent_target_reached() -> void:
	if target is Train:
		target.health_component.damage(1)
		queue_free()
