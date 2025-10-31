extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
var line_nodes: Array[Line2D] = []


func _ready():
	var parent_anchor = get_parent() as Anchor
	parent_anchor.on_disabled.connect(on_anchor_disabled)

func on_anchor_disabled():
	unlink_all()

func link(anchor: Anchor):
	print("Linking anchor")
	_create_line(anchor)
	linked_anchors.append(anchor)
	%Label.text = str(linked_anchors.size())

func unlink_all():
	for anchor in linked_anchors:
		anchor.electric_link.unlink_anchor(get_parent() as Anchor)
	for line in line_nodes:
		line.queue_free()
	line_nodes.clear()
	%Label.text = str(linked_anchors.size())
	linked_anchors.clear()

func unlink_anchor(anchor: Anchor):
	if !linked_anchors.has(anchor):
		return
	print("Unlinking anchor")
	var index = linked_anchors.find(anchor)
	var line = line_nodes[index]
	line.queue_free()
	line_nodes.remove_at(index)
	linked_anchors.remove_at(index)


func _create_line(anchor: Anchor):
	var line = Line2D.new()
	line.width = 4
	line.default_color = Color.CYAN
	line.points = [Vector2.ZERO, anchor.global_position - get_parent().global_position]
	line.position = Vector2.ZERO
	get_parent().add_child(line)
	line_nodes.append(line)
