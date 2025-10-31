extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
var line_nodes: Array[Line2D] = []
var electric_line_scene: PackedScene = preload("res://scenes/anchors/electric_line/electric_line.tscn")

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

func unlink_all():
	for line_node in line_nodes:
		line_node.queue_free()
	line_nodes.clear()
	linked_anchors.clear()

func unlink_anchor(anchor: Anchor):
	if anchor in linked_anchors:
		var index = linked_anchors.find(anchor)
		linked_anchors.erase(anchor)
		var line_node = line_nodes[index]
		line_node.queue_free()
		line_nodes.erase(line_node)
		%Label.text = str(linked_anchors.size())

func _create_line(anchor: Anchor):
	var line: ElectricLine = electric_line_scene.instantiate()
	var vector = anchor.global_position - get_parent().global_position
	line.set_endpoints(Vector2.ZERO, vector)
	get_parent().add_child(line)
	line_nodes.append(line)
	if get_instance_id() > anchor.electric_link.get_instance_id():
		line.hide()
