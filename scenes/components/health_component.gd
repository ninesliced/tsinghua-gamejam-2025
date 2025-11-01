extends Node2D

class_name HealthComponent

@export var max_health: int = 100
@export var health_bar: bool = true

var _current_health: int :
	set(x):
		_current_health = x
		if _health_bar:
			_health_bar.value = float(_current_health) / float(max_health) * 100.0

@onready var _health_bar : ProgressBar = %HealthBar

signal on_damaged(amount: int)
signal on_healed(amount: int)
signal on_dead()

func _ready() -> void:
	_current_health = max_health
	_health_bar.visible = health_bar

func damage(amount: int) -> void:
	on_damaged.emit(amount)
	_current_health -= amount
	if _current_health <= 0:
		_current_health = 0
		on_dead.emit()

func heal(amount: int) -> void:
	var prev_health: int = _current_health
	_current_health = max(_current_health + amount, max_health)
	on_healed.emit(_current_health - prev_health)
