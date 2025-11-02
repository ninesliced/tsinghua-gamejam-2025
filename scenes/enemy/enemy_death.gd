extends Node2D

@onready var time_loss_indicator: Label = %TimeLossIndicator

func _ready() -> void:
	var offset := Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var rotation := randf_range(-0.2, 0.2)
	
	time_loss_indicator.text = "-5s"
	time_loss_indicator.position = offset
	time_loss_indicator.rotation = rotation
	
	var tween := create_tween()
	tween.tween_property(time_loss_indicator, "position:y", offset.y - 20, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(time_loss_indicator, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", queue_free)
