extends Control


func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			resume_game()
		else:
			pause_game()
			

func _on_main_menu_button_pressed():
	await GameGlobal.change_scene_to_main_menu()
	resume_game()


func _on_resume_button_pressed():
	resume_game()


func resume_game():
	get_tree().paused = false
	hide()

func pause_game():
	get_tree().paused = true
	show()


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value / 100.)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value / 100.)
