extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
# var line_nodes: Array[Line2D] = []
var line_nodes: Dictionary[Anchor, ElectricLine] = {}
var electric_line_scene: PackedScene = preload("res://scenes/anchors/electric_line/electric_line.tscn")

signal on_linked(anchor: Anchor)
signal on_emptied()


signal on_surcharged()
signal on_decharged()

var surcharged: bool = false

var generator_linkeds: Array[Anchor] = []

func _ready():
	var parent_anchor = get_parent() as Anchor
	parent_anchor.on_disabled.connect(on_anchor_disabled)
	SignalBus.on_anchor_disabled.connect(unlink_anchor)

func on_anchor_disabled():
	unlink_all()

var i = 0
#DEGEUX
func _process(delta: float) -> void:
	if generator_linkeds.size() == 0:
		return

	i += 1
	if i % 5 != 0 or i == 0:
		return
	i = 0
	for i in range(linked_anchors.size()):
		var anchor = linked_anchors[i]
		if line_nodes.has(anchor) == false:
			continue
		var line_node = line_nodes[anchor]
		var start = get_parent().anchor_mark.position
		var end = anchor.anchor_mark.global_position - get_parent().anchor_mark.global_position + get_parent().anchor_mark.position
		line_node.set_endpoints(start, end)
		line_node.setup_line()
		line_node.update_line()

func decharge(anchor: Anchor):
	generator_linkeds.erase(anchor)
	if generator_linkeds.size() == 0:
		for line in line_nodes.values():
			line.hide()
		surcharged = false
		on_decharged.emit()

func link(anchor: Anchor):
	_create_line(anchor)
	linked_anchors.append(anchor)
	on_linked.emit(anchor)
	SignalBus.on_anchor_linked.emit(anchor)

func unlink_all():
	for anchor in linked_anchors:
		unlink_anchor(anchor)
	generator_linkeds.clear()


func unlink_anchor(anchor: Anchor):
	if !anchor in linked_anchors:
		return

	var index = linked_anchors.find(anchor)
	linked_anchors.erase(anchor)

	generator_linkeds.erase(anchor)
	if linked_anchors.size() == 0:
		on_emptied.emit()
	SignalBus.on_anchor_unlinked.emit(anchor)
	if line_nodes.has(anchor) == true:
		var line_node = line_nodes[anchor]
		line_node.queue_free()
		line_nodes.erase(anchor)
	%Label.text = str(linked_anchors.size())


func _create_line(anchor: Anchor):
	if get_instance_id() > anchor.electric_link.get_instance_id():
		return
	var line: ElectricLine = electric_line_scene.instantiate()
	var vector = anchor.global_position - get_parent().global_position
	var start = get_parent().anchor_mark.position
	var end = anchor.anchor_mark.global_position - get_parent().anchor_mark.global_position + get_parent().anchor_mark.position
	line.set_endpoints(start, end)
	get_parent().add_child(line)
	line_nodes[anchor] = line
	line.hide()

func surcharge(generator_anchor: Anchor):
	if generator_anchor in generator_linkeds:
		return
	generator_linkeds.append(generator_anchor)

	surcharged = true
	for line in line_nodes.values():
		line.show()
	on_surcharged.emit()

func _on_electric_field_zone_area_exited(area: Area2D):
	if not area is ElectricFieldZone:
		return
	var anchor = area.get_parent() as Anchor
	unlink_anchor(anchor)
