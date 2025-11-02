extends Node2D

class_name HealthComponent

@export var max_health: int = 100
@export var health_bar: bool = true

@onready var damage_indicator: Label = %DamageIndicator

var _current_health: int :
	set(x):
		_current_health = x
		if _health_bar:
			_health_bar.value = float(_current_health) / float(max_health) * 100.0

@onready var _health_bar : TextureProgressBar = %HealthBar

signal on_damaged(amount: int)
signal on_healed(amount: int)
signal on_dead()

func _ready() -> void:
	_current_health = max_health
	_health_bar.visible = health_bar

func damage(amount: int) -> void:
	_health_bar.visible = true
	on_damaged.emit(amount)
	_current_health -= amount
	if _current_health <= 0:
		_current_health = 0
		on_dead.emit()
	
	var offset := Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var rotation := randf_range(-0.2, 0.2)
	var dmg_label := damage_indicator.duplicate() as Label
	
	dmg_label.visible = true
	dmg_label.text = str(amount)
	dmg_label.position = offset
	dmg_label.rotation = rotation
	add_child(dmg_label)
	
	var tween := create_tween()
	tween.tween_property(dmg_label, "position:y", offset.y - 20, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(dmg_label, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", dmg_label.queue_free)

func heal(amount: int) -> void:
	var prev_health: int = _current_health
	_current_health = max(_current_health + amount, max_health)
	on_healed.emit(_current_health - prev_health)
