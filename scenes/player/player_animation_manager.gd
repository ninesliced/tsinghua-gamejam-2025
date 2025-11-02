extends AnimationPlayer
class_name PlayerAnimationManager


@export var display_node : Node2D
@export var particules_node : CPUParticles2D
@export var dirt_particules_node : CPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_movement_component_on_stop():
	play("idle", 1)
	particules_node.emitting = false
	dirt_particules_node.emitting = false
	#await 3 seconds
	await get_tree().create_timer(0.2).timeout
	pass # Replace with function body.

func _on_movement_component_on_move(direction: Vector2):
	particules_node.emitting = true
	dirt_particules_node.emitting = true
	if (direction.y != 0):
		if direction.y < 0:
			play("up")
		else:
			play("down")
	else:
		play("side")
		display_node.scale.x = 1 if direction.x >= 0 else -1
	pass # Replace with function body.
