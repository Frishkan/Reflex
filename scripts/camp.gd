extends Node2D
class_name Camp

@onready var hud : Node2D = $/root/game/hud
@onready var map : Node2D = $/root/game/map

var exited_by_button = false
var room_type : Room.Type

func _on_rest_pressed() -> void:
	Singleton.hero_health += Singleton.hero_max_health * 0.2
	if Singleton.hero_health > Singleton.hero_max_health :
		Singleton.hero_health = Singleton.hero_max_health
	hud.update_hero_health()
	map.show_map()
	map.unlock_next_rooms()
	hud.visible = false
	queue_free()

func _on_upgrade_toggled(toggled_on: bool) -> void:
	hud.open_deck(0, toggled_on, true)


var array : Array
var num : int
var seeking : int = 5

func _ready() :
	while num != seeking :
		num = randi_range(0, 100)
		array.append(num)
	print(array)
