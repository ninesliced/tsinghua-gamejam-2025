extends Node2D

class_name Bullet

var direction: Vector2
var speed: float
var damage: int
@onready var electric_line: ElectricLine = %ElectricLine

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	electric_line.rotation = direction.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		return

	queue_free()
	
	if body is Enemy:
		body.health_component.damage(damage)
		body.apply_knockback(direction, 10)

func _on_timer_timeout() -> void:
	queue_free()
