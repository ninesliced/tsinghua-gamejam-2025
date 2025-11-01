extends Node

@export var player: Player
@export var normal: Normal
@export var movement_component: MovementComponent
@export var dash_speed: float = 350.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

var is_dashing: bool = false
var dash_time_remaining: float = 0.0
var cooldown_time_remaining: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var last_movement_direction: Vector2 = Vector2.RIGHT

signal on_dash_start()
signal on_dash_end()

func _ready() -> void:
	if movement_component:
		movement_component.on_move.connect(_on_movement)
		movement_component.on_stop.connect(_on_stop)

func _process(delta: float) -> void:
	if cooldown_time_remaining > 0:
		cooldown_time_remaining -= delta
	
	if Input.is_action_just_pressed("dash") and can_dash():
		start_dash()
	
	if is_dashing:
		dash_time_remaining -= delta
		
		if dash_time_remaining <= 0:
			end_dash()

func _physics_process(delta: float) -> void:
	if is_dashing and player:
		player.velocity = dash_direction * dash_speed

func can_dash() -> bool:
	return not is_dashing and normal.enabled and cooldown_time_remaining <= 0

func start_dash() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	if input_dir != Vector2.ZERO:
		dash_direction = input_dir
	else:
		dash_direction = last_movement_direction
	
	is_dashing = true
	dash_time_remaining = dash_duration
	cooldown_time_remaining = dash_cooldown
	
	if movement_component:
		movement_component.disable()
	
	emit_signal("on_dash_start")

func end_dash() -> void:
	is_dashing = false
	dash_time_remaining = 0.0
	
	if movement_component:
		movement_component.enable()
	
	emit_signal("on_dash_end")

func _on_movement(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		last_movement_direction = direction

func _on_stop() -> void:
	pass
