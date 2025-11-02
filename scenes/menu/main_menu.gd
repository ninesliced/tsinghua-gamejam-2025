extends Node2D

func _ready() -> void:
	get_tree().paused = false
	Audio.fighting.stop()
	Audio.exploring.stop()

func _on_button_pressed() -> void:
	TransitionManager.change_scene(preload("res://scenes/level1.tscn"), "circle_gradient")
	Audio.menu.stop()
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed() -> void:
	TransitionManager.change_scene(preload("res://scenes/tutorial.tscn"), "circle_gradient")
	Audio.menu.stop()
	pass
