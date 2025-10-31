extends PathFollow2D

@export var speed: float = 50
var moving: bool = false

func _process(delta: float) -> void:
	if moving:
		progress += delta * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		moving = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		moving = false
