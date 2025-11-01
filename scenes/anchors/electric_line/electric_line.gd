extends Line2D
class_name ElectricLine
var original_points: Array = []
@export var noise_amplitude: float = 0.1
@export var number_of_segments: int = 3
@export var update_frequency: float = 0.5
var num_points: int = 0
var timer: Timer = null
var start : Vector2
var end : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	setup_line()
	#TIMER SETUP
	# timer = Timer.new()
	# timer.wait_time = update_frequency
	# timer.one_shot = false
	# timer.autostart = true
	# add_child(timer)
	# timer.timeout.connect(update_line)

func setup_line():
	var vector = end - start
	var segment_length = vector.length() / number_of_segments
	vector = vector.normalized()

	var start_point = start
	var end_point = end
	
	clear_points()

	#ADD POINTS
	add_point(start_point)
	for i in range(1, number_of_segments):
		var point = start_point + vector * segment_length * i
		add_point(point)
	add_point(end_point)

	original_points = points

func get_original_in_between_points() -> Array[Vector2]:
	var res: Array[Vector2] = []
	for i in range(1, original_points.size()-1):
		res.append(original_points[i])
	return res

func update_line():
	var start_point = get_point_position(0)
	var end_point = get_point_position(points.size() - 1)
	clear_points()
	closed = false
	var new_points = get_original_in_between_points().duplicate()
	for i in range(new_points.size()):
		new_points[i] += Vector2(
			randf_range(-noise_amplitude, noise_amplitude),
			randf_range(-noise_amplitude, noise_amplitude)
		)
	points = [start_point] + new_points + [end_point]

func set_endpoints(s: Vector2, e: Vector2) -> void:
	start = s
	end = e
	
	var line: SegmentShape2D = %CollisionLine.shape
	line.a = start
	line.b = end


func _on_area_body_entered(body: Node2D) -> void:
	if not body is Enemy:
		return
	
	var enemy: Enemy = body
	enemy.health_component.damage(1)
