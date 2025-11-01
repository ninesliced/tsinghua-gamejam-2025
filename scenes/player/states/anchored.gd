extends State
class_name Anchored
@export var movement_component: MovementComponent
@export var speed : float = 150.0
@export var max_speed : float = 300.0
@export var speed_multiplier : float = 1.2
@export var player_shape: CollisionShape2D
var current_speed : float = 0.0:
	set(value):
		current_speed = value
		velocity = direction * pow(current_speed, 1.22)
var enabled: bool = false
var player: Player = null
var selected_anchor: Anchor = null
var anchor_checkeds: Array[Anchor] = []

var moving_to_anchor: bool = false
var target_anchor: Anchor = null
var lose_speed_stack_timer: Timer = null
var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var tween : Tween = null

@export var lose_speed_stack_interval : float = 1.0

func on_entity_set():
	player = entity as Player
	pass

func lose_speed_stack():
	if current_speed > speed:
		current_speed = max(current_speed / speed_multiplier, speed)

func enter():
	player_shape.disabled = true
	enabled = true
	movement_component.disable()
	player.velocity = Vector2(0, 0)
	current_speed = speed

	lose_speed_stack_timer = Timer.new()
	lose_speed_stack_timer.wait_time = lose_speed_stack_interval
	lose_speed_stack_timer.timeout.connect(lose_speed_stack)
	lose_speed_stack_timer.one_shot = false
	lose_speed_stack_timer.start()
	add_child(lose_speed_stack_timer)
	pass

func _input(event):
	if not enabled:
		return
	if event.is_action_pressed("interact") and !moving_to_anchor:
		call_deferred("emit_state_finished")
	pass

func emit_state_finished():
	state_finished.emit(self, "Normal")

func process(delta):
	if target_anchor == null:
		print("No target anchor selected")
		return
	if target_anchor.electric_link.surcharged == false:
		emit_state_finished()
	pass

func physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	direction = (mouse_pos - player.global_position).normalized()
	if moving_to_anchor:
		return
	var input_vector = Input.get_vector("left", "right", "up", "down")
	if input_vector == Vector2(0, 0):
		return
	var best_anchor = _get_best_anchor_in_direction(input_vector)
	if best_anchor != null:
		move_to_anchor(best_anchor)

	pass

func exit():
	player_shape.disabled = false
	current_speed = speed
	enabled = false
	movement_component.enable()
	anchor_checkeds.clear()
	lose_speed_stack_timer.stop()
	# player.velocity = velocity
	if tween != null:
		tween.stop()
	moving_to_anchor = false
	pass

func move_to_anchor(target_anchor: Anchor) -> void:
	self.target_anchor = target_anchor
	print(self.target_anchor)
	lose_speed_stack_timer.stop()
	current_speed = min(current_speed * speed_multiplier, max_speed)
		
	moving_to_anchor = true
	tween = player.create_tween()
	var target_position = target_anchor.anchor_mark.global_position

	var distance = player.global_position.distance_to(target_position)
	var duration = distance / current_speed
	direction = (target_position - player.global_position).normalized()
	tween.tween_property(player, "global_position", target_position, duration)
	var on_tween_completed = func():
		selected_anchor = target_anchor
		moving_to_anchor = false
		lose_speed_stack_timer.start()
	tween.finished.connect(on_tween_completed)

func _get_linked_anchors() -> Array:
	return selected_anchor.electric_link.linked_anchors

func _get_best_anchor_in_direction(input_vector: Vector2) -> Anchor:
	var best_anchor: Anchor = null
	var best_score := -1.0
	
	for anchor in _get_linked_anchors():
		var dir = (anchor.global_position - selected_anchor.global_position).normalized()
		var dot = dir.dot(input_vector.normalized())

		if dot > 0.3:
			var dist = selected_anchor.global_position.distance_to(anchor.global_position)
			var score = dot / dist
			if score > best_score:
				best_score = score
				best_anchor = anchor
				
	return best_anchor

# # Creates a map of direction vectors to linked anchors, so if the player move to a direction, it'll go to the anchor
# func create_vector_map() -> Dictionary:
# 	print("-------------")
# 	var vector_map: Dictionary = {}
# 	var linked_anchors = _get_linked_anchors().duplicate()
# 	var remaining_anchors: Array = linked_anchors.duplicate()
# 	var vectors: Array = [
# 		Vector2(0, -1),
# 		Vector2(1, 0),
# 		Vector2(0, 1),
# 		Vector2(-1, 0),
# 		Vector2(-1, -1),
# 		Vector2(1, -1),
# 		Vector2(1, 1),
# 		Vector2(-1, 1),
# 	]

# 	for vec in vectors:
# 		var best_anchor = null
# 		var best_dot = -1.0
# 		for anchor in linked_anchors:
# 			var direction = (anchor.global_position - selected_anchor.global_position).normalized()
# 			var dot = direction.dot(vec)
# 			if dot > best_dot and remaining_anchors.has(anchor):
# 				best_dot = dot
# 				best_anchor = anchor
# 		vector_map[vec] = best_anchor
# 		remaining_anchors.erase(best_anchor)

# 	# chose the best matching vector for each anchor first
# 	for anchor in linked_anchors:
# 		print("azeaz: ", anchor)
# 		var direction = (anchor.global_position - selected_anchor.global_position).normalized()
# 		if (!vectors.size()):
# 			print("ran out of vectors, shouldn't HAPPEN ")
# 			break
# 		var best_vector = vectors[0]
# 		for vec in vectors:
# 			if direction.dot(vec) > direction.dot(best_vector):
# 				best_vector = vec
# 		vector_map[best_vector] = anchor
# 		vectors.erase(best_vector)
# 	# then fill in the remaining vectors
	
# 	return vector_map

# func normalized_to_one_vector(vec: Vector2) -> Vector2:
# 	var x = 0
# 	var y = 0

# 	if vec.x > 0:
# 		x = 1
# 	elif vec.x < 0:
# 		x = -1

# 	if vec.y > 0:
# 		y = 1
# 	elif vec.y < 0:
# 		y = -1

# 	print(vec, " -> ", Vector2(x, y))
# 	return Vector2(x, y)
	
			


# func print_map(map: Dictionary) -> void:
# 	var name_dict = {
# 		Vector2(0, -1): "up",
# 		Vector2(1, 0): "right",
# 		Vector2(0, 1): "down",
# 		Vector2(-1, 0): "left",
# 		Vector2(-1, -1).normalized(): "up-left",
# 		Vector2(1, -1).normalized(): "up-right",
# 		Vector2(1, 1).normalized(): "down-right",
# 		Vector2(-1, 1).normalized(): "down-left",
# 	}
# 	for vec in map.keys():
# 		var anchor = map[vec]
# 		print(name_dict.get(vec, "unknown"), " -> ", anchor)
	
