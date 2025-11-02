extends Node

@export var anchor: Anchor
@export var train: Train

func _ready():
	anchor.electric_link.on_surcharged.connect(_on_anchor_surcharged)
	anchor.electric_link.on_decharged.connect(_on_anchor_decharged)

func _on_anchor_surcharged():
	if (!Audio.charging.playing):
		Audio.charging.play()
	train.moving = true

func _on_anchor_decharged():
	train.moving = false
	Audio.charging.stop()
