extends Path2D

class_name Railway

@export var ways: Array[Curve2D] = []
@export var timers: Array[float] = []

var _way_index: int = 0
var _timer_index: int = 0

func _ready() -> void:
	GameGlobal.train.train_reached_end.connect(_start_next_timer)

	curve = ways[_way_index]
	$Timer.wait_time = timers[_way_index]
	$Timer.start()

func next_way() -> bool:
	_way_index += 1
	if _way_index >= ways.size():
		return false
	curve = ways[_way_index]
	return true

func is_last_way() -> bool:
	return _way_index >= ways.size() - 1

func _on_timer_timeout() -> void:
	if _timer_index == 0:
		GameGlobal.train.reached_end = false
	else:
		GameGlobal.train.train_next_way.emit()

func _start_next_timer() -> void:
	_timer_index += 1
	if _timer_index >= timers.size():
		return
	$Timer.wait_time = timers[_timer_index]
	$Timer.start()
