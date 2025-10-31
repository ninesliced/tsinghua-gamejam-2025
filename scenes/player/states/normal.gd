extends State

@export var anchor_manager : AnchorManager

var enabled: bool = true

func on_entity_set():
	pass

func enter():
	enabled = true
	anchor_manager.enable()

func process(delta):
	pass

func _input(event):
	if not enabled:
		return
	if event.is_action_pressed("place_anchor"):
		anchor_manager.handle_anchor_action()

func physics_process(delta):
	pass

func exit():
	enabled = false
	anchor_manager.disable()
