extends Node2D

class_name EnergyComponent

@export var max_energy: int = 100
var current_energy: int

signal on_energy_loss(amount: int)
signal on_energy_gained(amount: int)
signal energy_empty()

func _ready() -> void:
	current_energy = max_energy

func consume_energy(amount: int) -> void:
	on_energy_loss.emit(amount)
	current_energy -= amount
	if current_energy <= 0:
		current_energy = 0
		energy_empty.emit()

func recharge_energy(amount: int) -> void:
	var prev_health: int = current_energy
	current_energy = max(current_energy + amount, max_energy)
	on_energy_gained.emit(current_energy - prev_health)
