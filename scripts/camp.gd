extends Node2D
class_name Camp

var exited_by_button = false
var room_type : Room.Type

func _on_rest_pressed() -> void:
	Singleton.hero_health += Singleton.hero_max_health * 0.2
	if Singleton.hero_health > Singleton.hero_max_health :
		Singleton.hero_health = Singleton.hero_max_health
	$/root/game/hud.update_hero_health()
	$/root/game/map.show_map()
	$/root/game/map.unlock_next_rooms()
	$/root/game/hud.visible = false
	queue_free()

func _on_upgrade_toggled(toggled_on: bool) -> void:
	$/root/game/hud.open_deck(0, toggled_on, true)


var array : Array
var num : int
var seeking : int = 5

func _ready() :
	while num != seeking :
		num = randi_range(0, 100)
		array.append(num)
	print(array)
