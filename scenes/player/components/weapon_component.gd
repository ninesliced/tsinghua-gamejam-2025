extends Node2D

class_name WeaponComponent

signal weapon_changed(new_weapon: WeaponData)

var weapon_data: WeaponData = null :
	set(x):
		weapon_data = x
		weapon_changed.emit(x)
		%Weapon.weapon_data = x
