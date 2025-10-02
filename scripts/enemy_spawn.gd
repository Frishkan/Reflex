class_name FightScene
extends Node2D

const ENEMY_ASSEMBLED = preload("res://scenes/enemy_assembled.tscn")
const REWARDS = preload("res://scenes/rewards.tscn")
@onready var enemies_node : Node2D = %Enemies

@export var attacker_weight := 8.0
@export var tank_weight := 2.5
@export var buffer_weight := 2.0
@export var debuffer_weight := 4.0
var room_type : Room.Type


const FUNCTIONS := {
	Card.Name.KNIFE: ["knife", [20, 5, 300, 0, false, -1]], ## QTE type, [dmg per hit, max hits, speed, dmg penalty for each miss, hero recieving?, multiplier : damage(-); heal(+)]
	Card.Name.SKILLFULL_BARRAGE: ["guitar_hero", [3, 10, 400, 2, false, -1]],
}

var rand_weights = {
	Enemy.Type.ATTACKER1: 0.0,
	Enemy.Type.TANK1: 0.0,
	Enemy.Type.BUFFER1: 0.0,
	Enemy.Type.DEBUFFER1: 0.0
}

var rand_total_weight := 0
var enemies : Array


func _ready() -> void:
	Events.card_played.connect(_card_played)
	spawn_enemy()

func spawn_enemy() :
	var enemy_type_array : Array = get_enemies_array()
	
	for enemy_index in enemy_type_array.size() :
		var enemy_instance = ENEMY_ASSEMBLED.instantiate() as EnemyAssembled
		enemies_node.add_child(enemy_instance)
		enemy_instance.index = enemy_index
		enemy_instance.set_enemy(enemy_type_array[enemy_index - 1])

func get_enemies_array() -> Array :
	setup_weights()
	var enemy_count = randi_range(1, 3)
	for enems in enemy_count :
		var enemy : Enemy.Type = roll_enemy_type()
		enemies.append(enemy)
		
	if room_type == 5 :
		enemies[0] = Enemy.Type.ELITE1
	
	if room_type == 6:
		enemies[0] = Enemy.Type.BOSS1
	
	return enemies

func roll_enemy_type() -> Enemy.Type :
	var roll := randf_range(1, rand_total_weight)
	
	for type : Enemy.Type in rand_weights :
		if rand_weights[type] > roll :
			var enemy_type_int : int = type
			return roll_enemy_variant(enemy_type_int)
	
	return Enemy.Type.ATTACKER1

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

func _card_played(hand_card : HandCard) :
	$QTEs.call(FUNCTIONS[hand_card.hand_card_name][0], FUNCTIONS[hand_card.hand_card_name][1])

func output(result : int, hero : bool) :
	if !hero : ## damaging (accessing monster hp)
		enemies_node.get_children()[enemies_node.get_children().size() - 1].change_health(result)
	else :
		Singleton.health += result
	


func _on_enemies_child_exiting_tree(node: Node) -> void:
	if enemies_node.get_child_count() == 1 : 
		print(enemies_node.get_child_count())
		var rewards_scene = REWARDS.instantiate()
		rewards_scene.start(room_type)
		add_child(rewards_scene)
