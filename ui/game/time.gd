extends Label

func _on_game_on_time_changed(time_left: float):
	time_left = int(time_left)
	text = "Time Left: " + str(time_left)
