extends PathFollow2D

class_name Train

@export var speed: float = 50
var moving: bool = false

var _railway: Railway = null

signal train_start_moving()
signal train_stop_moving()

func _ready() -> void:
	var parent: Node = get_parent()
	if parent is Railway:
		_railway = parent
	else:
		assert(false, "Train must be a child of Railway")

func _process(delta: float) -> void:
	if moving:
		progress += delta * speed
		if progress_ratio == 1:
			_railway.next_way.emit(1)
			progress_ratio = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		moving = true
		train_start_moving.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		moving = false
		train_stop_moving.emit()
