extends Node2D

class_name Weapon

@onready var _delay_timer: Timer = %DelayTimer
@export var weapon_data: WeaponData :
	set(x):
		weapon_data = x
		if weapon_data == null:
			return
		
		if %Sprite:
			%Sprite.texture = weapon_data.texture
		if _delay_timer:
			_delay_timer.wait_time = weapon_data.delay
var _can_shoot: bool = true

func _process(delta: float) -> void:
	if not weapon_data:
		return

	var mouse_position: Vector2 = get_global_mouse_position()
	var direction: Vector2 = (mouse_position - global_position).normalized()
	if direction.x < 0:
		%Sprite.flip_v = true
		%Sprite.rotation = direction.angle()
	else:
		%Sprite.flip_v = false
		%Sprite.rotation = direction.angle()

	%Sprite.position = direction * 7
	
	if Input.is_action_pressed("shoot"):
		if weapon_data.automatic:
			if _can_shoot:
				_can_shoot = false
				_delay_timer.start()
				shoot()
		else:
			if Input.is_action_just_pressed("shoot") and _can_shoot:
				_can_shoot = false
				_delay_timer.start()
				shoot()

func shoot() -> void:
	if not weapon_data:
		return
	
	for i in range(weapon_data.bullets_per_shot):
		var mouse_angle := (get_global_mouse_position() - global_position).angle()
		var angle_offset := randf_range(-weapon_data.spread_angle / 2, weapon_data.spread_angle / 2)
		_spawn_bullet(mouse_angle + deg_to_rad(angle_offset))
		if i < weapon_data.bullets_per_shot - 1:
			await get_tree().create_timer(weapon_data.fire_rate).timeout

func _spawn_bullet(angle_offset: float) -> void:
	var bullet_scene: PackedScene = preload("res://scenes/weapons/bullet.tscn")
	var bullet_instance: Bullet = bullet_scene.instantiate()
	
	var direction: Vector2 = Vector2.RIGHT.rotated(angle_offset)
	bullet_instance.global_position = global_position + direction * 10
	bullet_instance.direction = direction
	bullet_instance.speed = weapon_data.bullet_speed
	bullet_instance.damage = weapon_data.damage
	
	get_tree().current_scene.add_child(bullet_instance)

func _on_delay_timer_timeout() -> void:
	_can_shoot = true
