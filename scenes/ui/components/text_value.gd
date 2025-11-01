extends HBoxContainer
class_name TextValueUI
@onready var number: Label = %Number

func set_value(value: String) -> void:
    number.text = value