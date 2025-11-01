extends AnimatedSprite2D

var previous_position: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	previous_position = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = global_position - previous_position
	
	#play animation based on movement
	play_animation_based_on_movement(movement)
	previous_position = global_position

func play_animation_based_on_movement(movement: Vector2) -> void:
	if movement.length() < 0.1:
		return
	var angle = movement.angle()
	if angle > -PI/4 and angle <= PI/4:
		play("side")
		flip_h = false
	elif angle > PI/4 and angle <= 3*PI/4:
		play("down")
		flip_h = false
	elif angle <= -PI/4 and angle > -3*PI/4:
		play("up")
		flip_h = false
	else:
		play("side")
		flip_h = true