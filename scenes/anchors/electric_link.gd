extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
var line_nodes: Array[Line2D] = []
var electric_line_scene: PackedScene = preload("res://scenes/anchors/electric_line/electric_line.tscn")

signal on_linked(anchor: Anchor)
signal on_emptied()

func _ready():
	var parent_anchor = get_parent() as Anchor
	parent_anchor.on_disabled.connect(on_anchor_disabled)
	SignalBus.on_anchor_disabled.connect(unlink_anchor)

func on_anchor_disabled():
	unlink_all()

func link(anchor: Anchor):
	_create_line(anchor)
	linked_anchors.append(anchor)
	%Label.text = str(linked_anchors.size())
	on_linked.emit(anchor)

func unlink_all():
	for line_node in line_nodes:
		line_node.queue_free()
	line_nodes.clear()
	linked_anchors.clear()
	on_emptied.emit()

func unlink_anchor(anchor: Anchor):
	if anchor in linked_anchors:
		var index = linked_anchors.find(anchor)
		linked_anchors.erase(anchor)
		var line_node = line_nodes[index]
		line_node.queue_free()
		line_nodes.erase(line_node)
		%Label.text = str(linked_anchors.size())
	if linked_anchors.size() == 0:
		on_emptied.emit()

func _create_line(anchor: Anchor):
	var line: ElectricLine = electric_line_scene.instantiate()
	var vector = anchor.global_position - get_parent().global_position
	var start = get_parent().anchor_mark.position
	var end = anchor.anchor_mark.global_position - get_parent().anchor_mark.global_position + get_parent().anchor_mark.position
	line.set_endpoints(start, end)
	get_parent().add_child(line)
	line_nodes.append(line)
	if get_instance_id() > anchor.electric_link.get_instance_id():
		line.hide()
