extends Node2D

@onready var map = $map
@onready var hud = $hud

const FIGHT_SCENE = preload("res://scenes/fight_scene.tscn")
const CAMP = preload("res://scenes/camp.tscn")

func _ready() -> void:
	Events.map_exited.connect(_map_exited)

func _map_exited(room: Room) :
	map.hide_map()
	hud.visible = true
	Singleton.run_rooms += 1
	go_to(room.type)

func go_to(type: Room.Type) :
	print("went to ", type) ## match: 
	var room_instance : Node2D
	match type :
		Room.Type.MONSTER :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
		Room.Type.ELITE :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
		Room.Type.BOSS :
			room_instance = FIGHT_SCENE.instantiate() as FightScene
		Room.Type.CAMPFIRE :
			room_instance = CAMP.instantiate() as Camp
	room_instance.room_type = type
	self.add_child(room_instance)
