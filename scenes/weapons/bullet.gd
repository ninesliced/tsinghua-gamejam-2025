extends Node2D

class_name Bullet

var direction: Vector2
var speed: float
var damage: int

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
	
	if body is Enemy:
		body.health_component.damage(damage)


func _on_timer_timeout() -> void:
	queue_free()
