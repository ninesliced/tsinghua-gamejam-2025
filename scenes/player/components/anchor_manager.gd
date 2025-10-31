extends Node
class_name AnchorManager

@export var anchor_max = 3
@export var list_anchors: Array[Anchor] = []
@onready var anchor_scene: PackedScene = preload("res://scenes/anchors/anchor.tscn")

func _ready():
	for i in range(anchor_max):
		var anchor = anchor_scene.instantiate() as Anchor
		list_anchors.append(anchor)
	pass

func use_anchor():
	if list_anchors.size() < 1:
		return
	var anchor = list_anchors.pop_back()
	get_tree().get_root().add_child(anchor)
	anchor.set_process(true)


func add_anchor(anchor: Anchor):
	if list_anchors.size() >= anchor_max:
		return
	list_anchors.append(anchor)
	self.add_child(anchor)
	anchor.set_process(false)
