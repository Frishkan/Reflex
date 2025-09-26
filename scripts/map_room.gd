class_name MapRoom
extends Area2D

signal selected(room : Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2(1, 1)],
	Room.Type.MONSTER: [preload("res://textures/monster.png"), Vector2(4, 4), Vector2(0.2, 0.2)],
	Room.Type.TREASURE: [preload("res://textures/Chalice.png"), Vector2(10, 10), Vector2(0.1, 0.1)],
	Room.Type.CAMPFIRE: [preload("res://textures/Camp.png"), Vector2(10, 10), Vector2(0.1, 0.1)],
	Room.Type.SHOP: [preload("res://textures/Shop.png"), Vector2(6, 6), Vector2(0.1, 0.1)],
	Room.Type.ELITE: [preload("res://textures/Elite.png"), Vector2(7.2, 7.2), Vector2(0.1, 0.1)],
	Room.Type.BOSS: [preload("res://textures/Boss.png"), Vector2(12, 12), Vector2(0.1, 0.1)]
}

@onready var sprite_2d : Sprite2D = $Visuals/Sprite2D
@onready var line_2d : Line2D = $Visuals/Line2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer



var available := false : set = set_available
var room : Room : set = set_room

func set_available(new_value : bool) -> void :
	available = new_value 
	
	if available :
		animation_player.play("highlight")
	elif not room.selected :
		animation_player.play("RESET")

func set_room(new_data : Room ) -> void :
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][2]
	self.scale = ICONS[room.type][1]

func show_selected() -> void :
	line_2d.modulate = Color.WHITE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse") :
		return
	
	get_parent().get_parent().get_parent().lock_all_rooms()
	room.selected = true
	animation_player.play("select")

## anim player calls when "select" ends
func _on_map_room_selected() -> void :
	selected.emit(room)
