extends Node2D
class_name Tutorial

enum GameState {
	NOTHING,
	INIT_PREPARATION,
	FIGHT,
	EXPLORATION,
	GAME_OVER,
	YOU_WIN
}

@export var time_each_round : float = 60.0
var game_state : GameState = GameState.NOTHING

@onready var time = $UI/Time

var time_dict : Dictionary = {
	GameState.INIT_PREPARATION: 10.0,
	GameState.FIGHT: 60.0,
	GameState.EXPLORATION: 30.0
}

var time_left : float = time_each_round
var level : int = 0

signal on_time_changed(time_left: float)
signal on_tutorial_state_changed(old_state: GameState, new_state: GameState)
signal on_level_changed(new_level: int)

func _ready():
	get_tree().paused = false
	time.hide()
	GameGlobal.train.railway.tutorial = true
	GameGlobal.train.railway.is_tutorial()
	GameGlobal.tutorial = self
	setup_time()
	GameGlobal.train.train_reached_end.connect(change_to_exploration)


func _process(delta):
	if (game_state != GameState.NOTHING):
		time_left -= delta
	emit_signal("on_time_changed", time_left)
	if time_left <= 0:
		on_time_up()
	if (GameGlobal.train.moving and game_state != GameState.FIGHT):
		change_to_fight()


func change_to_exploration() -> void:
	Audio.fighting.stop()
	Audio.exploring.play()
	
	if GameGlobal.train.railway.is_over():
		change_state(GameState.YOU_WIN)
		return
	
	change_state(GameState.EXPLORATION)
	
func change_to_fight() -> void:
	Audio.fighting.play()
	Audio.exploring.stop()
	time.show()
	
	change_state(GameState.FIGHT)

func change_state(new_state: GameState):
	var old_state = game_state
	game_state = new_state
	on_tutorial_state_changed.emit(old_state, new_state)
	
	if new_state == GameState.FIGHT:
		level += 1
		on_level_changed.emit(level)
	setup_time()

func on_time_up():
	match game_state:
		GameState.INIT_PREPARATION:
			Audio.exploring.stop()
			Audio.fighting.play()
			return change_state(GameState.FIGHT)
		GameState.FIGHT:
			return change_state(GameState.GAME_OVER)
		GameState.EXPLORATION:
			Audio.exploring.stop()
			Audio.fighting.play()
			return change_state(GameState.FIGHT)
	on_tutorial_state_changed.emit(game_state, game_state)
	setup_time()

func setup_time():
	if time_dict.has(game_state):
		time_left = time_dict[game_state]
	else:
		time_left = time_each_round


func _on_game_on_time_changed(time_left: float) -> void:
	pass # Replace with function body.
