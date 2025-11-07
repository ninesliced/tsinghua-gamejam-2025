extends Node

class_name MovementComponent

var _player : Player = null
var velocity = Vector2(0, 0)
var can_accelerate = true
var can_decelerate = true
var _disabled = false
var _moving = false
@export var time_to_accelerate = 0.2
@export var time_to_decelerate = 0.1
@export var speed = 150
@onready var movement_sound = $Movement

signal on_move(velocity: Vector2)
signal on_stop()

func _ready():
	var parent = get_parent()
	if parent is Player:
		_player = parent
	else:
		assert(false, "MovementController must be a child of Player")

func disable():
	_disabled = true

func enable():
	_disabled = false


func _process(delta):
	pass

func _physics_process(delta):
	if _disabled:
		return
	velocity = handle_movement(delta, _player.velocity)
	_player.velocity = velocity
	



func handle_movement(delta, velocity):
	var new_velocity = Vector2(0, 0)
	var vec = Input.get_vector("left", "right", "up", "down")

	vec = vec.normalized()
	if vec == Vector2(0, 0):
		emit_signal("on_stop")
		movement_sound.stop()
		_moving = false
	else:
		emit_signal("on_move", vec)
		if !_moving:
			_moving = true
			movement_sound.play()
	new_velocity = handle_acceleration_decceleration(delta, vec, velocity)
	
	return new_velocity

func handle_acceleration_decceleration(delta, vec, velocity):
	var new_velocity = Vector2(0, 0)
	var acceleration = speed / time_to_accelerate
	var friction = speed / time_to_decelerate

	if vec != Vector2(0, 0) and can_accelerate:
		new_velocity = velocity.move_toward(vec * speed, acceleration * delta)
	elif can_decelerate:
		new_velocity = velocity.move_toward(Vector2(0, 0), friction * delta)
	return new_velocity
