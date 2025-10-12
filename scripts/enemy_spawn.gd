class_name EnemySpawning
extends Node2D

const ENEMY_ASSEMBLED = preload("res://scenes/enemy_assembled.tscn")

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
	
	for enemy_index in enemy_type_array.size() :
		var enemy_instance = ENEMY_ASSEMBLED.instantiate() as EnemyAssembled
		self.add_child(enemy_instance)
		enemy_instance.index = enemy_index
		enemy_instance.set_enemy(enemy_type_array[enemy_index - 1])
		enemy_instance.get_child(3).start()

func get_enemies_array() -> Array :
	setup_weights()
	var enemy_count = randi_range(1, 3)
	for enems in enemy_count :
		var enemy : Enemy.Type = roll_enemy_type()
		enemies.append(enemy)
		
	if get_parent().room_type == 5 :
		enemies[0] = Enemy.Type.ELITE1
	
	if get_parent().room_type == 6:
		enemies[0] = Enemy.Type.BOSS1
	
	return enemies

func roll_enemy_type() -> Enemy.Type :
	var roll := randf_range(1, rand_total_weight)
	
	for type : Enemy.Type in rand_weights :
		if rand_weights[type] > roll :
			var enemy_type_int : int = type
			return roll_enemy_variant(enemy_type_int)
	
	return Enemy.Type.DUMMY

func roll_enemy_variant(enemy_type_int : int) -> Enemy.Type:
	var roll := randi_range(1, 5)
	match enemy_type_int :
		1 :
			return Enemy.Type.ATTACKER1
		2 :
			return Enemy.Type.TANK1
		3 :
			return Enemy.Type.BUFFER1
		4 :
			return Enemy.Type.DEBUFFER1
		_ : 
			return Enemy.Type.DUMMY


func setup_weights() -> void :
	rand_weights[Enemy.Type.ATTACKER1] = attacker_weight
	rand_weights[Enemy.Type.TANK1] = attacker_weight + tank_weight
	rand_weights[Enemy.Type.BUFFER1] = attacker_weight + tank_weight + buffer_weight
	rand_weights[Enemy.Type.DEBUFFER1] = attacker_weight + tank_weight + buffer_weight + debuffer_weight
	
	rand_total_weight = rand_weights[Enemy.Type.DEBUFFER1]
