extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
var line_nodes: Array[Line2D] = []


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
	print("Creating line to anchor: ", anchor.get_instance_id())
	var line = Line2D.new()
	line.width = 4
	line.default_color = Color.CYAN
	line.points = [Vector2.ZERO, anchor.global_position - get_parent().global_position]
	line.position = Vector2.ZERO
	get_parent().add_child(line)
	line_nodes.append(line)
