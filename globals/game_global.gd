extends Node

var train: Train = null
var player: Player = null
var game: Game = null:
	set(value):
		game = value
		game_ready.emit()

signal game_ready()

func change_scene_to_main_menu():
	#TransitionManager.change_scene(preload("res://scenes/menu/main_menu.tscn"), "circle_gradient")
	pass

func change_scene_to_game():
	#TransitionManager.change_scene(preload("res://scenes/level1.tscn"), "circle_gradient")
	pass
