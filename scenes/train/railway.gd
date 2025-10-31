extends Path2D

class_name Railway

@export var ways: Array[Curve2D] = []
var way_index: int = 0

signal next_way(step: int)

func _ready() -> void:
	curve = ways[way_index]
	next_way.connect(next_way_step)

func _process(delta: float) -> void:
	pass

func next_way_step(step: int) -> void:
	way_index += step
	if way_index < 0:
		way_index = ways.size() - way_index
	elif way_index >= ways.size():
		way_index = way_index % ways.size()
	curve = ways[way_index]
	print("Switched to way index: %d" % way_index)
