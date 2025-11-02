extends NinePatchRect

func _ready() -> void:
	await GameGlobal.game_ready
	GameGlobal.game.on_game_state_changed.connect(_on_game_state_changed)
	visible = false

func _on_game_state_changed(old_state: Game.GameState, new_state: Game.GameState) -> void:
	print(new_state)
	if new_state == Game.GameState.YOU_WIN:
		show_menu()

func show_menu() -> void:
	visible = true
	get_tree().paused = true

func _on_retry_pressed() -> void:
	TransitionManager.reload_scene("square_gradient")


func _on_menu_pressed() -> void:
	GameGlobal.change_scene_to_main_menu()
