extends Node
class_name GeneratorComponent

@export var electric_link: ElectricLink

var anchors_surcharged: Array[Anchor] = []

func _ready() -> void:
	electric_link.on_linked.connect(_on_linked)
	SignalBus.on_anchor_disabled.connect(give_energy)
	SignalBus.on_anchor_linked.connect(give_energy)
	SignalBus.on_anchor_unlinked.connect(give_energy)

func give_energy(_anchor: Anchor) -> void:

	var old_anchors_surcharged: Array[Anchor] = anchors_surcharged.duplicate()
	for anchor in anchors_surcharged:
		anchor.electric_link.generator_linkeds.erase(get_parent() as Anchor)
	anchors_surcharged.clear()
	for anchor in electric_link.linked_anchors:
		give_energy_to_anchor(anchor)

	for anchor in old_anchors_surcharged:
		if anchors_surcharged.has(anchor) == false:
			anchor.electric_link.decharge(get_parent() as Anchor)



func _on_linked(anchor: Anchor) -> void:
	give_energy_to_anchor(anchor)

func give_energy_to_anchor(anchor: Anchor) -> void:
	var electric_link: ElectricLink = anchor.electric_link
	if electric_link == null:
		return
	if electric_link.generator_linkeds.has(get_parent() as Anchor):
		return

	electric_link.surcharge(get_parent() as Anchor)
	anchors_surcharged.append(anchor)

	for linked_anchor in electric_link.linked_anchors:
		give_energy_to_anchor(linked_anchor)
