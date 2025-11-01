extends CharacterBody2D
class_name Player
@onready var anchor_manager: AnchorManager = %AnchorManager

func _physics_process(delta):
	move_and_slide()
	pass
