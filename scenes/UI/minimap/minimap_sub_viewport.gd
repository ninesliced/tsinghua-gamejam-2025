extends SubViewport

@onready var player: CharacterBody2D = $"../../../Player"
@onready var camera_2d: Camera2D = $Camera2D

var player_minimap_sprite: Sprite2D
var anchor_minimap_sprites: Dictionary = {}
var enemy_minimap_sprites: Dictionary = {}
var anchor_lines: Array[Line2D] = []

func _ready() -> void:
	world_2d = World2D.new()
	transparent_bg = true

	create_player_minimap_sprite()

	if is_instance_valid(camera_2d):
		camera_2d.enabled = true

	if player and player.anchor_manager:
		player.anchor_manager.on_anchor_used.connect(_on_anchor_used)
		player.anchor_manager.on_anchor_added.connect(_on_anchor_added)

	_register_existing_enemies()
	get_tree().node_added.connect(_on_tree_node_added)
	get_tree().node_removed.connect(_on_tree_node_removed)

func _physics_process(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(camera_2d):
		camera_2d.position = player.position

	if player_minimap_sprite and is_instance_valid(player):
		player_minimap_sprite.global_position = player.global_position

	for anchor in anchor_minimap_sprites.keys():
		if is_instance_valid(anchor) and anchor_minimap_sprites.has(anchor):
			anchor_minimap_sprites[anchor].global_position = anchor.global_position
			anchor_minimap_sprites[anchor].visible = anchor.visible

	for enemy in enemy_minimap_sprites.keys():
		if is_instance_valid(enemy) and enemy_minimap_sprites.has(enemy):
			enemy_minimap_sprites[enemy].global_position = enemy.global_position
			enemy_minimap_sprites[enemy].visible = enemy.visible

	_update_anchor_lines()

func _update_anchor_lines() -> void:
	var active_anchors: Array[Anchor] = []
	for anchor in anchor_minimap_sprites.keys():
		if is_instance_valid(anchor) and anchor.visible:
			active_anchors.append(anchor)

	for line in anchor_lines:
		if is_instance_valid(line):
			line.queue_free()
	anchor_lines.clear()

	for i in range(active_anchors.size()):
		for linked in active_anchors[i].electric_link.linked_anchors:
			var line = Line2D.new()
			line.default_color = Color.YELLOW
			line.width = 4.0
			line.add_point(active_anchors[i].global_position)
			line.add_point(linked.global_position)
			add_child(line)
			anchor_lines.append(line)


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

func create_enemy_minimap_sprite(enemy: Enemy) -> Sprite2D:
	var enemy_sprite := Sprite2D.new()

	var tilesheet = load("res://assets/tilesheet/minimap_tilemap.png")
	enemy_sprite.texture = tilesheet

	enemy_sprite.region_enabled = true

	enemy_sprite.region_rect = Rect2(0, 8*4 + 4*1, 8, 8)

	enemy_sprite.scale = Vector2(2, 2)

	add_child(enemy_sprite)
	return enemy_sprite

func _track_enemy(enemy: Enemy) -> void:
	if enemy_minimap_sprites.has(enemy):
		return
	var sprite := create_enemy_minimap_sprite(enemy)
	enemy_minimap_sprites[enemy] = sprite
	enemy.tree_exited.connect(_on_enemy_tree_exited.bind(enemy))

func _untrack_enemy(enemy: Enemy) -> void:
	if enemy_minimap_sprites.has(enemy):
		if is_instance_valid(enemy_minimap_sprites[enemy]):
			enemy_minimap_sprites[enemy].queue_free()
		enemy_minimap_sprites.erase(enemy)

func _register_existing_enemies() -> void:
	var stack: Array = [get_tree().root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n is Enemy:
			_track_enemy(n)
		for c in n.get_children():
			stack.append(c)

func _on_tree_node_added(node: Node) -> void:
	if node is Enemy:
		_track_enemy(node)

func _on_tree_node_removed(node: Node) -> void:
	if node is Enemy:
		_untrack_enemy(node)

func _on_enemy_tree_exited(enemy: Enemy) -> void:
	_untrack_enemy(enemy)

func _on_anchor_used(anchor: Anchor) -> void:
	if not anchor_minimap_sprites.has(anchor):
		var sprite = create_anchor_minimap_sprite(anchor)
		anchor_minimap_sprites[anchor] = sprite

func _on_anchor_added(anchor: Anchor) -> void:
	if anchor_minimap_sprites.has(anchor):
		anchor_minimap_sprites[anchor].queue_free()
		anchor_minimap_sprites.erase(anchor)
