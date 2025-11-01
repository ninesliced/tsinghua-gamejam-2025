extends Node2D
class_name Game

enum GameState {
	INIT_PREPARATION,
	FIGHT,
	EXPLORATION,
	GAME_OVER
}

@export var time_each_round : float = 60.0
var game_state : GameState = GameState.INIT_PREPARATION

var time_dict : Dictionary = {
	GameState.INIT_PREPARATION: 5.0,
	GameState.FIGHT: 60.0,
	GameState.EXPLORATION: 30.0
}

var time_left : float = time_each_round
var level : int = 0

signal on_time_changed(time_left: float)
signal on_game_state_changed(old_state: GameState, new_state: GameState)
signal on_level_changed(new_level: int)

func _ready():
	GameGlobal.game = self
	setup_time()
	GameGlobal.train.train_reached_end.connect(change_to_exploration)


func _process(delta):
	time_left -= delta
	emit_signal("on_time_changed", time_left)
	if time_left <= 0:
		on_time_up()

func change_to_exploration():
	change_state(GameState.EXPLORATION)

func change_state(new_state: GameState):
	var old_state = game_state
	game_state = new_state
	on_game_state_changed.emit(old_state, new_state)
	
	if new_state == GameState.FIGHT:
		level += 1
		on_level_changed.emit(level)
	setup_time()

func on_time_up():
	match game_state:
		GameState.INIT_PREPARATION:
			return change_state(GameState.FIGHT)
		GameState.FIGHT:
			return change_state(GameState.EXPLORATION)
		GameState.EXPLORATION:
			return change_state(GameState.FIGHT)
	on_game_state_changed.emit(game_state, game_state)
	setup_time()

func setup_time():
	if time_dict.has(game_state):
		time_left = time_dict[game_state]
	else:
		time_left = time_each_round
