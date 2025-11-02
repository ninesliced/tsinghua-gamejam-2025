extends NinePatchRect

@onready var info_ui: RichTextLabel = %InfoLabel

func _ready() -> void:
	await GameGlobal.game_ready
	GameGlobal.train.health_component.on_dead.connect(show_menu)
	GameGlobal.game.on_game_state_changed.connect(_on_game_state_changed)
	visible = false

func _on_game_state_changed(old_state: int, new_state: int) -> void:
	if new_state == Game.GameState.GAME_OVER:
		show_menu()

func show_menu() -> void:
	set_values()
	visible = true

func _on_retry_pressed() -> void:
	TransitionManager.reload_scene("square_gradient")


func _on_menu_pressed() -> void:
	GameGlobal.change_scene_to_main_menu()


func set_values() -> void:
	if !GameGlobal.game:
		return
	
	info_ui.text = "You reached the station %d/%d !\n" % [
		GameGlobal.game.level - 1,
		GameGlobal.train.railway.ways.size()
	]
