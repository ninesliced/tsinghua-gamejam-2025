extends NinePatchRect

func _ready() -> void:
	await GameGlobal.tutorial_ready
	GameGlobal.tutorial.on_tutorial_state_changed.connect(_on_game_state_changed)
	visible = false

func _on_game_state_changed(old_state: Tutorial.GameState, new_state: Tutorial.GameState) -> void:
	print(new_state)
	if new_state == Tutorial.GameState.YOU_WIN:
		show_menu()

func show_menu() -> void:
	visible = true
	get_tree().paused = true

func _on_retry_pressed() -> void:
	TransitionManager.reload_scene("square_gradient")


func _on_menu_pressed() -> void:
	GameGlobal.change_scene_to_main_menu()
