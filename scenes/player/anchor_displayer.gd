extends Node2D

var anchor_display_scene : PackedScene = preload("res://scenes/anchors/anchor_display.tscn")
@export var anchor_manager: AnchorManager
@export var player: Player
var list_displayed_anchors: Array[AnchorDisplay] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_manager.on_anchor_added.connect(_on_anchor_added)
	anchor_manager.on_anchor_used.connect(_on_anchor_used)

func _on_anchor_added(anchor: Anchor):
	var instance = anchor_display_scene.instantiate() as AnchorDisplay
	instance.global_position = anchor.global_position
	if list_displayed_anchors.size() > 0:
		instance.anchor_target = list_displayed_anchors[ list_displayed_anchors.size() - 1 ]
	else:
		instance.anchor_target = player
	add_child(instance)
	list_displayed_anchors.append(instance)

func _on_anchor_used(anchor: Anchor):
	if list_displayed_anchors.size() < 1:
		return
	var display = list_displayed_anchors.pop_back()
	display.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
