extends AnimationPlayer
class_name PlayerAnimationManager


@export var display_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_movement_component_on_stop():
	play("idle", 1)
	pass # Replace with function body.

func _on_movement_component_on_move(direction: Vector2):
	print(direction)
	if (direction.y != 0):
		print("Vertical movement detected")
		if direction.y < 0:
			play("up")
		else:
			play("down")
	else:
		play("side")
		display_node.scale.x = 1 if direction.x >= 0 else -1
	pass # Replace with function body.
