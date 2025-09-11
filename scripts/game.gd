extends Node2D


func _ready() -> void:
	Events.map_exited.connect(_map_exited)

func _map_exited(room: Room) :
	$map.hide_map()
	$hud.visible = true
	go_to(room.type)

func go_to(type: Room.Type) :
	print("went to ", type) ## match: get_tree().change_scene_file_to("")
