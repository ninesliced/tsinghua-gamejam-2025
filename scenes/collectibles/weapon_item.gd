extends Node2D
class_name WeaponItem

@export var weapon_data: WeaponData :
	set(x):
		weapon_data = x
		if %Sprite:
			%Sprite.texture = weapon_data.texture

var _can_pickup := false :
	set(x):
		_can_pickup = x
		%HintText.visible = x

func _ready() -> void:
	%Sprite.texture = weapon_data.texture

func _process(delta: float) -> void:
	if _can_pickup and Input.is_action_just_pressed("pickup"):
		var player: Player = GameGlobal.player
		var prev_weapon = player.weapon.weapon_data
		player.weapon.weapon_data = weapon_data
		
		if prev_weapon:
			weapon_data = prev_weapon
		else:
			queue_free()


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	_can_pickup = true
