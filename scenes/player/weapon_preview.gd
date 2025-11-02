extends Node2D

@export var color: Color = Color(1, 1, 1, 0.4)
var tween: Tween = null
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = color
	SignalBus.on_shoot.connect(on_shoot)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	# rotation = direction.angle()
	rotation = rotate_toward(rotation, direction.angle(), 10 * delta)
	pass

func on_shoot():
	modulate = Color(1, 1, 1, 1)
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", color.a, 0.2)
	tween.play()
