extends Area2D
class_name PlayerInteractionZone

var player : Player
signal on_player_entered(player: Player)
signal on_player_exited(player: Player)

func _on_body_exited(body: Node2D):
	if !(body is Player):
		return
	player = null
	on_player_exited.emit(body)

func _on_body_entered(body: Node2D):
	if !(body is Player):
		return
	player = body
	on_player_entered.emit(body)
