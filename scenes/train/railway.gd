extends Path2D

class_name Railway

@export var ways: Array[Curve2D] = []
@export var timers: Array[float] = []

signal on_new_way()

var _way_index: int = -1
var _timer_index: int = 0

func _ready() -> void:
	on_new_way.connect(GameGlobal.train._train_next_way)
	pass

func next_way() -> bool:
	_way_index += 1
	if _way_index >= ways.size():
		return false
	curve = ways[_way_index]
	return true


func _on_game_on_game_state_changed(old_state: Game.GameState, new_state: Game.GameState):
	if new_state == Game.GameState.FIGHT:
		on_new_way.emit()
		if _way_index == -1:
			_way_index = 0
			return
		next_way()

	pass # Replace with function body.
