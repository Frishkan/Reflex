extends Node2D

const FIGHT_SCENE = preload("res://scenes/fight_scene.tscn")

func _ready() -> void:
	Events.map_exited.connect(_map_exited)

func _map_exited(room: Room) :
	$map.hide_map()
	$hud.visible = true
	go_to(room.type)

func go_to(type: Room.Type) :
	print("went to ", type) ## match: 
	if type == Room.Type.MONSTER :
		var room_instance = FIGHT_SCENE.instantiate() as FightScene
		self.add_child(room_instance)
