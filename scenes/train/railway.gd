extends Path2D

class_name Railway

@export var ways: Array[Curve2D] = []
@export var timers: Array[float] = []

signal on_new_way()

var _way_index: int = -1
var _timer_index: int = 0

func _ready() -> void:
	curve = ways[0]
	on_new_way.connect(GameGlobal.train._train_next_way)
	if !GameGlobal.game:
		await GameGlobal.game_ready
	GameGlobal.game.on_game_state_changed.connect(_on_game_on_game_state_changed)
	pass

func next_way() -> bool:
	_way_index += 1
	if _way_index == 0:
		return true
	if _way_index >= ways.size():
		return false
	curve = ways[_way_index]
	return true


func _on_game_on_game_state_changed(old_state: Game.GameState, new_state: Game.GameState):
	if new_state == Game.GameState.FIGHT:
		if (next_way()):
			on_new_way.emit()

	pass # Replace with function body.

func is_over():
	return _way_index >= ways.size() - 1
