extends AnimatedSprite2D
class_name ElectricLinkSprite
@export var electric_line : ElectricLine
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_electric_link_on_emptied():
	play("default")
	electric_line.hide()
	pass # Replace with function body.

func _on_electric_link_on_linked(anchor: Anchor):
	play("linked")
	electric_line.show()
	pass # Replace with function body.
