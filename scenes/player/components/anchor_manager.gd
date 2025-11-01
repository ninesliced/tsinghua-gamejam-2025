extends Node
class_name AnchorManager

@export var anchor_max = 3
@export var list_anchors: Array[Anchor] = []
@onready var anchor_scene: PackedScene = preload("res://scenes/anchors/anchor.tscn")

signal on_anchor_used(anchor: Anchor)
signal on_anchor_added(anchor: Anchor)

var enabled: bool = false
var anchors_in_range: Array[Anchor] = []

func _ready():
	for i in range(anchor_max):
		var anchor = anchor_scene.instantiate() as Anchor
		list_anchors.append(anchor)
		self.add_child(anchor)
		anchor.disable()
		on_anchor_added.emit(anchor)
	pass

func handle_anchor_action():
	if anchors_in_range.size() > 0:
		var nearest_anchor = null
		var nearest_distance = INF
		for anchor in anchors_in_range:
			var distance = anchor.global_position.distance_to(get_parent().global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_anchor = anchor
		if nearest_anchor != null:
			add_anchor(nearest_anchor)
	else:
		use_anchor()
	pass

func use_anchor():
	if not enabled:
		return
	if list_anchors.size() < 1:
		return
	var anchor = list_anchors.pop_back()
	
	anchor.get_parent().remove_child(anchor)
	get_tree().get_root().add_child(anchor)
	anchor.global_position = get_parent().global_position
	anchor.enable()
	on_anchor_used.emit(anchor)
	SignalBus.on_anchor_placed.emit(anchor)


func add_anchor(anchor: Anchor):
	if not enabled:
		return
	if list_anchors.size() >= anchor_max:
		return
	list_anchors.append(anchor)
	self.add_child(anchor)
	anchor.disable()
	on_anchor_added.emit(anchor)
	anchors_in_range.erase(anchor)

func enable():
	enabled = true

func disable():
	enabled = false
