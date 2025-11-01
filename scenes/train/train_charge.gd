extends Node

@export var anchor: Anchor
@export var train: Train

func _ready():
	anchor.electric_link.on_surcharged.connect(_on_anchor_surcharged)
	anchor.electric_link.on_decharged.connect(_on_anchor_decharged)

func _on_anchor_surcharged():
	train.moving = true

func _on_anchor_decharged():
	print("train stopped")
	train.moving = false
