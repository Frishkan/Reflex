class_name FightScene
extends Node2D

const ENEMY_ASSEMBLED = preload("res://scenes/enemy_assembled.tscn")
@onready var enemies_node : Node2D = %Enemies

@export var attacker_weight := 8.0
@export var tank_weight := 2.5
@export var buffer_weight := 2.0
@export var debuffer_weight := 4.0

var rand_weights = {
	Enemy.Type.ATTACKER1: 0.0,
	Enemy.Type.TANK1: 0.0,
	Enemy.Type.BUFFER1: 0.0,
	Enemy.Type.DEBUFFER1: 0.0
}

var rand_total_weight := 0
var enemies : Array


func _ready() -> void:
	spawn_enemy()

func spawn_enemy() :
	var enemy_type_array : Array = get_enemies_array()
	
	for enemy_type in enemy_type_array :
		var enemy_instance = ENEMY_ASSEMBLED.instantiate() as EnemyAssembled
		enemies_node.add_child(enemy_instance)
		enemy_instance.index = enemy_type_array.find(enemy_type)
		enemy_instance.set_enemy(enemy_type)

func get_enemies_array() -> Array :
	setup_weights()
	var enemy_count = randi_range(1, 3)
	for enems in enemy_count :
		var enemy : Enemy.Type = roll_enemy_type()
		print(enemy, " <- the type itself")
		enemies.append(enemy)
	
	return enemies

func roll_enemy_type() -> Enemy.Type :
	var roll := randf_range(1, rand_total_weight)
	
	for type : Enemy.Type in rand_weights :
		if rand_weights[type] > roll :
			var enemy_type_int : int = type
			print(enemy_type_int, " <- enemy type int")
			return roll_enemy_variant(enemy_type_int)
	
	return Enemy.Type.ATTACKER1

func roll_enemy_variant(enemy_type_int : int) -> Enemy.Type:
	var roll := randi_range(1, 5)
	match enemy_type_int :
		1 :
			print(enemy_type_int)
			return Enemy.Type.ATTACKER1
		2 :
			print(enemy_type_int)
			return Enemy.Type.TANK1
		3 :
			print(enemy_type_int)
			return Enemy.Type.BUFFER1
		4 :
			print(enemy_type_int)
			return Enemy.Type.DEBUFFER1
		_ : 
			print(enemy_type_int, " didnt detect as number")
			return Enemy.Type.DUMMY
	return Enemy.Type.DUMMY


func setup_weights() -> void :
	rand_weights[Enemy.Type.ATTACKER1] = attacker_weight
	rand_weights[Enemy.Type.TANK1] = attacker_weight + tank_weight
	rand_weights[Enemy.Type.BUFFER1] = attacker_weight + tank_weight + buffer_weight
	rand_weights[Enemy.Type.DEBUFFER1] = attacker_weight + tank_weight + buffer_weight + debuffer_weight
	
	rand_total_weight = rand_weights[Enemy.Type.DEBUFFER1]
