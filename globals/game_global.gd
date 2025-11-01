extends Node

var train: Train = null
var player: Player = null
var game: Game = null:
	set(value):
		game = value
		game_ready.emit()

signal game_ready()
