@tool
extends CollisionShape2D

@export var level: int = 1:
	set(value):
		level = value
		%Label.text = str(level)
@export var spawn_interval: Vector2 = Vector2(1, 3)
@export var enemy_scene: PackedScene

var _active := false

@onready var _spawn_timer: Timer = %Timer

signal on_enemy_spawned(enemy: Node2D)
signal on_spawner_activated()
signal on_spawner_deactivated()

func _ready() -> void:
	await GameGlobal.game_ready
	GameGlobal.game.on_level_changed.connect(_level_changed)
	GameGlobal.game.on_game_state_changed.connect(_exploration_mode)
	%Label.hide()

func _exploration_mode(old_state: Game.GameState, new_state: Game.GameState) -> void:
	if _active and new_state == Game.GameState.EXPLORATION:
		_active = false
		_spawn_timer.stop()
		on_spawner_deactivated.emit()

func _level_changed(new_level: int) -> void:
	if new_level == level:
		_active = true
		_spawn_timer.wait_time = randf_range(spawn_interval.x, spawn_interval.y)
		_spawn_timer.start()
		on_spawner_activated.emit()
	elif _active:
		_active = false
		_spawn_timer.stop()
		on_spawner_deactivated.emit()


func _on_timer_timeout() -> void:
	if not _active:
		return
	
	var enemy_instance: Enemy = enemy_scene.instantiate()
	var spawn_position: Vector2 = Vector2.ZERO
	
	if shape is RectangleShape2D:
		var rect_shape: RectangleShape2D = shape as RectangleShape2D
		var extents: Vector2 = rect_shape.size / 2
	
		spawn_position.x = randf_range(-extents.x, extents.x)
		spawn_position.y = randf_range(-extents.y, extents.y)
	
	enemy_instance.global_position = global_position + spawn_position
	get_parent().add_child(enemy_instance)
	
	_spawn_timer.wait_time = randf_range(spawn_interval.x, spawn_interval.y)
	_spawn_timer.start()
	
	on_enemy_spawned.emit(enemy_instance)
