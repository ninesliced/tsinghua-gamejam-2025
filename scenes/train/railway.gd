extends Path2D

class_name Railway

@export var ways: Array[Curve2D] = []
var way_index: int = 0

func _ready() -> void:
	curve = ways[way_index]

func next_way() -> bool:
	way_index += 1
	if way_index >= ways.size():
		return false
	curve = ways[way_index]
	return true

func is_last_way() -> bool:
	return way_index >= ways.size() - 1
