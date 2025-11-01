extends SubViewport

@onready var player: CharacterBody2D = $"../../../Player"
@onready var camera_2d: Camera2D = $Camera2D

var player_minimap_sprite: Sprite2D
var anchor_minimap_sprites: Dictionary = {}

func _ready() -> void:
	world_2d = World2D.new()
	transparent_bg = true

	create_player_minimap_sprite()

	if is_instance_valid(camera_2d):
		camera_2d.enabled = true

	if player and player.anchor_manager:
		player.anchor_manager.on_anchor_used.connect(_on_anchor_used)
		player.anchor_manager.on_anchor_added.connect(_on_anchor_added)

func _physics_process(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(camera_2d):
		camera_2d.position = player.position

	if player_minimap_sprite and is_instance_valid(player):
		player_minimap_sprite.global_position = player.global_position

	for anchor in anchor_minimap_sprites.keys():
		if is_instance_valid(anchor) and anchor_minimap_sprites.has(anchor):
			anchor_minimap_sprites[anchor].global_position = anchor.global_position
			anchor_minimap_sprites[anchor].visible = anchor.visible

func create_player_minimap_sprite() -> void:
	player_minimap_sprite = Sprite2D.new()

	var tilesheet = load("res://assets/tilesheet/minimap_tilemap.png")
	player_minimap_sprite.texture = tilesheet

	player_minimap_sprite.region_enabled = true
	player_minimap_sprite.region_rect = Rect2(0, 0, 8, 8)

	player_minimap_sprite.scale = Vector2(2, 2)

	add_child(player_minimap_sprite)

func create_anchor_minimap_sprite(anchor: Anchor) -> Sprite2D:
	var anchor_sprite = Sprite2D.new()

	var tilesheet = load("res://assets/tilesheet/minimap_tilemap.png")
	anchor_sprite.texture = tilesheet

	anchor_sprite.region_enabled = true
	anchor_sprite.region_rect = Rect2(0, 8*3 + 3*1, 8, 8)

	anchor_sprite.scale = Vector2(2, 2)

	add_child(anchor_sprite)
	return anchor_sprite

func _on_anchor_used(anchor: Anchor) -> void:
	if not anchor_minimap_sprites.has(anchor):
		var sprite = create_anchor_minimap_sprite(anchor)
		anchor_minimap_sprites[anchor] = sprite

func _on_anchor_added(anchor: Anchor) -> void:
	if anchor_minimap_sprites.has(anchor):
		anchor_minimap_sprites[anchor].queue_free()
		anchor_minimap_sprites.erase(anchor)
