extends Node2D
class_name Anchor

var can_collect: bool = false
var player: Player = null

signal on_disabled()
signal on_enabled()

@export var pickable: bool = true
@export var can_be_anchored_state: bool = true
@export var enabled_by_default : bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = %AnchorSprite
@onready var electric_link: ElectricLink = $ElectricLink
@onready var electric_field_zone: ElectricFieldZone = $ElectricFieldZone
@onready var player_interaction_zone: Area2D = $PlayerInteractionZone
@onready var anchor_mark: Marker2D = %AnchorMark

func _on_player_interaction_zone_on_player_exited(player: Player):
	if is_processing() == false:
		return
	can_collect = false
	player.anchor_manager.anchors_in_range.erase(self)
	player = null

func _on_player_interaction_zone_on_player_entered(player: Player):
	if is_processing() == false:
		return
	can_collect = true
	# animated_sprite_2d.play("near")
	self.player = player
	player.anchor_manager.anchors_in_range.append(self)

func _ready():
	if enabled_by_default:
		enable()
		print("Anchor enabled by default")
		set_process(true)

func disable():
	can_collect = false
	set_process(false)
	hide()
	set_all_areas(false)
	on_disabled.emit()
	SignalBus.on_anchor_disabled.emit(self)

func enable():
	can_collect = true
	set_process(true)
	show()
	set_all_areas(true)
	on_enabled.emit()

func set_all_areas(bool_value: bool):
	if !electric_field_zone or !player_interaction_zone:
		return
	electric_field_zone.monitorable = bool_value
	electric_field_zone.monitoring = bool_value

	player_interaction_zone.monitorable = bool_value
	player_interaction_zone.monitoring = bool_value
