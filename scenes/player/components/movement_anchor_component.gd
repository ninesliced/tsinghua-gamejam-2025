extends Node

@export var anchor_manager : AnchorManager
@export var movement_component: MovementComponent

func on_collect_anchor(anchor: Anchor):
	movement_component.speed += 20

func on_use_anchor(anchor: Anchor):
	print("Anchor used, reducing speed")
	movement_component.speed -= 50
