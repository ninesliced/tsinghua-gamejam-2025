extends Area2D
class_name ElectricFieldZone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area: Area2D):
	print("ElectricFieldZone detected area entered: ", area.name)
	print(monitorable)
	print(monitoring)
	print(get_instance_id())
	if !(area is ElectricFieldZone):
		return

	print(get_instance_id(), " entered electric field zone of ", area.get_parent().get_instance_id())

	var anchor = area.get_parent() as Anchor
	anchor.electric_link.link(get_parent() as Anchor)

	pass # Replace with function body.
