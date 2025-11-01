extends NinePatchRect

@onready var score_ui: TextValueUI = %Score
@onready var seed_ui: TextValueUI = %Seed

func _ready() -> void:
	#SignalBus.on_player_died.connect(show_menu)
	visible = false
	pass

func show_menu() -> void:
	set_values()
	visible = true

func _on_retry_pressed() -> void:
	# TransitionManager.reload_scene("square_gradient")
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	Global.go_to_main_menu()
	pass # Replace with function body.


func set_values() -> void:
	if !GameGlobal.score_manager:
		return
	var score = GameGlobal.score_manager.score
	score_ui.set_value(str(score))

	var seed = GameGlobal.rng_seed
	seed_ui.set_value(str(seed))
