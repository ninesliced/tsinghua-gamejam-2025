extends Node2D


func _on_button_pressed() -> void:
	TransitionManager.change_scene(preload("res://scenes/level1.tscn"), "circle_gradient")
	pass
