extends CharacterBody2D
class_name Player

@onready var anchor_manager: AnchorManager = %AnchorManager
@onready var weapon: WeaponComponent = %WeaponComponent

func _ready() -> void:
	GameGlobal.player = self

func _physics_process(delta):
	move_and_slide()
	pass
