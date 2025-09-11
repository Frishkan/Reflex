class_name MapRoom
extends Area2D

signal selected(room : Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2(1, 1)],
	Room.Type.MONSTER: [preload("res://textures/monster.png"), Vector2(0.9, 0.9)],
	Room.Type.TREASURE: [preload("res://textures/Chalice.png"), Vector2(2.5, 2.5)],
	Room.Type.CAMPFIRE: [preload("res://textures/Camp.png"), Vector2(1, 1)],
	Room.Type.SHOP: [preload("res://textures/Shop.png"), Vector2(1.5, 1.5)],
	Room.Type.ELITE: [preload("res://textures/bitmap.png"), Vector2(1.8, 1.8)],
	Room.Type.BOSS: [preload("res://textures/Boss.png"), Vector2(3, 3)]
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
