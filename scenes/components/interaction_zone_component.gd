extends Area2D
class_name InteractionZoneComponent

var list_interactions_zones = []

func _on_area_entered(area: Area2D):
	if !area is PlayerInteractionZone:
		return

	list_interactions_zones.append(area)

func _on_area_exited(area: Area2D):
	if !area is PlayerInteractionZone:
		return

	list_interactions_zones.erase(area)

func get_nearest_interaction_zone(player: Player) -> PlayerInteractionZone:
	var nearest_zone: PlayerInteractionZone = null
	var nearest_distance: float = INF

	for zone in list_interactions_zones:
		var distance = zone.position.distance_to(player.position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_zone = zone

	return nearest_zone
