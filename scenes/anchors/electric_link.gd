extends Node2D
class_name ElectricLink

var linked_anchors: Array[Anchor] = []
var line_nodes: Array[Line2D] = []
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

	if int(i) % 1 != 0:
		i += delta*1000
		return
	i = 0
	for i in range(linked_anchors.size()):
		var anchor = linked_anchors[i]
		var line_node = line_nodes[i]
		var start = get_parent().anchor_mark.position
		var end = anchor.anchor_mark.global_position - get_parent().anchor_mark.global_position + get_parent().anchor_mark.position
		line_node.set_endpoints(start, end)
		line_node.setup_line()
		line_node.update_line()

func decharge(anchor: Anchor):
	generator_linkeds.erase(anchor)
	if generator_linkeds.size() == 0:
		for line in line_nodes:
			line.hide()
		surcharged = false
		print("Decharged")
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
	var line_node = line_nodes[index]
	line_node.queue_free()
	line_nodes.erase(line_node)
	%Label.text = str(linked_anchors.size())
	generator_linkeds.erase(anchor)
	if linked_anchors.size() == 0:
		on_emptied.emit()
	print("Anchor unlinked")
	SignalBus.on_anchor_unlinked.emit(anchor)
	print("signaled")

func _create_line(anchor: Anchor):
	var line: ElectricLine = electric_line_scene.instantiate()
	var vector = anchor.global_position - get_parent().global_position
	var start = get_parent().anchor_mark.position
	var end = anchor.anchor_mark.global_position - get_parent().anchor_mark.global_position + get_parent().anchor_mark.position
	line.set_endpoints(start, end)
	get_parent().add_child(line)
	line_nodes.append(line)
	line.hide()

func surcharge(generator_anchor: Anchor):
	if generator_anchor in generator_linkeds:
		return
	generator_linkeds.append(generator_anchor)

	surcharged = true
	for line in line_nodes:
		line.show()
	on_surcharged.emit()
	print("Surcharged")

func _on_electric_field_zone_area_exited(area: Area2D):
	if not area is ElectricFieldZone:
		return
	var anchor = area.get_parent() as Anchor
	unlink_anchor(anchor)
