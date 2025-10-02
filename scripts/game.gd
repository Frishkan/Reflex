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
	var room_instance : Node2D
	match type :
		Room.Type.MONSTER :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
			room_instance.room_type = type
			
		Room.Type.ELITE :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
			room_instance.room_type = type
			
		Room.Type.BOSS :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
			room_instance.room_type = type
		
	self.add_child(room_instance)
