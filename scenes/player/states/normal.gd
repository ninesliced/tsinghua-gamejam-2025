extends State

class_name Normal

@export var anchor_manager : AnchorManager
@export var interaction_zone_component: InteractionZoneComponent
@export var anchored_state : Anchored
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

	if event.is_action_pressed("interact"):
		var interaction_zone = interaction_zone_component.get_nearest_interaction_zone(entity)
		if interaction_zone == null:
			return
		var parent = interaction_zone.get_parent()
		if parent is Anchor and can_be_anchored(parent) and parent.can_be_anchored_state:
			anchored_state.selected_anchor = parent
			state_finished.emit(self, "Anchored")

func can_be_anchored(anchor: Anchor) -> bool:
	var anchor_elec_link = anchor.electric_link
	if anchor_elec_link.surcharged == false:
		return false
	if anchor.electric_link.linked_anchors.size() > 0:
		return true
	return false

func physics_process(delta):
	pass

func exit():
	enabled = false
	anchor_manager.disable()
