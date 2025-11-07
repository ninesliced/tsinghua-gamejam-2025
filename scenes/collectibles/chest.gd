extends Node2D

@export var items: Array[Resource] = []
var is_open : bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var interaction_area: Area2D = $Area2D
@onready var openchest_sound = $OpenChest

func _on_interaction_area_body_entered(body: Node) -> void:
	if body is Player and !is_open:
		is_open = true
		animated_sprite_2d.play("open")
		openchest_sound.play()
		if len(items) > 0:
			items.shuffle()
			var selected_item = items[0]
			if selected_item is WeaponData:
				var object = preload("res://scenes/collectibles/weapon_item.tscn").instantiate()
				get_parent().add_child(object)
				var weapon = object as WeaponItem
				weapon.weapon_data = selected_item
				weapon.global_position = global_position
			else:
				pass

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
