@tool
extends Node2D

@export var railway_path: Curve2D :
	set(x):
		railway_path = x
		$Path2D.curve = railway_path
@export var speed: float = 1

func _ready() -> void:
	$Path2D.curve = railway_path

func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += delta * speed
