extends Node2D
class_name AnchorDisplay
var anchor_target: Node2D
@onready var anchor_sprite: AnimatedSprite2D = %AnchorSprite

var delta_wave := 0.0
var speed_wave := 4.0

@export var min_distance_to_target := 15.0
@export var max_distance_to_target := 20.0
@export var speed_move := 5.0

var anchors_display_to_push := []


func _process(delta):
	handle_wave_animation(delta)
	if anchor_target == null:
		return
	var direction = anchor_target.position - position
	var distance = direction.length()
	if distance < min_distance_to_target:
		global_position -= direction.normalized() * speed_move * delta
	elif distance > max_distance_to_target:
		global_position += direction.normalized() * distance * speed_move * delta
	
	for anchor_display in anchors_display_to_push:
		var dir_push = position - anchor_display.position
		var dist_push = dir_push.length()
		if dist_push < max_distance_to_target:
			global_position += dir_push.normalized() * delta * speed_move
			print("PUSHING ANCHOR DISPLAY")


func handle_wave_animation(delta):
	delta_wave += delta * speed_wave
	if delta_wave > 2*PI:
		delta_wave -= 2*PI
	anchor_sprite.position.y += 0.1 * sin(delta_wave)


func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent is AnchorDisplay:
		parent.anchors_display_to_push.append(self)


func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	if parent is AnchorDisplay:
		parent.anchors_display_to_push.erase(self)
