extends PathFollow2D

class_name Train

@export var speed: float = 50
var moving: bool = false
var reached_end: bool = true

var _railway: Railway = null

signal train_start_moving()
signal train_stop_moving()
signal train_reached_end()

signal train_next_way()

func _ready() -> void:
	var parent: Node = get_parent()
	if parent is Railway:
		_railway = parent
	else:
		assert(false, "Train must be a child of Railway")
	
	train_next_way.connect(_train_next_way)
	GameGlobal.train = self

func _process(delta: float) -> void:
	if not moving or reached_end:
		return
	
	progress += delta * speed
	if progress_ratio == 1:
		train_reached_end.emit()
		reached_end = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		moving = true
		train_start_moving.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		moving = false
		train_stop_moving.emit()

func _train_next_way() -> void:
	reached_end = false
	if _railway.next_way():
		progress_ratio = 0
