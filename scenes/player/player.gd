extends CharacterBody2D
class_name Player

@onready var anchor_manager: AnchorManager = %AnchorManager
@onready var energy_component: EnergyComponent = %EnergyComponent

func _physics_process(delta):
	move_and_slide()
	pass
