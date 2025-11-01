extends Node2D

@export var item_data: Array[Resource] = []
var is_open : bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var interaction_area: Area2D = $Area2D

func _on_interaction_area_body_entered(body: Node) -> void:
	if body is Player and !is_open:
		is_open = true
		animated_sprite_2d.play("open")
		if (len(item_data) > 0):
			item_data.shuffle()
			var selected_item = item_data[0]
			print("Player collected item from chest:", selected_item)
			#body.inventory.add_item(selected_item)

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
