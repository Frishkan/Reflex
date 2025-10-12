extends Node2D

var possibility : Array
var value : Array ## [times applied, value for, type]
var order : int

@onready var intent_icon = $IntentSprite2D
@onready var intent_value = $IntentValue
@onready var player_dmg_number = $Game/FightScene/Hero/DMGNumber
@onready var hud = $Game/hud

func start() -> void:
	Events.enemy_turn_ended.connect(show_intents)
	Events.turn_ended.connect(use_intents, order)
	show_intents()
	get_order()

func get_order() :
	if get_parent().get_parent().get_child(2) == self :
		order = 1
	elif get_parent().get_parent().get_child(1) == self :
		order = 2
	else :
		order = 3


func show_intents() :
	generate_intents_by_type()
	self.visible = true

func generate_intents_by_type() :
	match get_parent().type : 
		Enemy.Type.ATTACKER1:
			possibility = ["attack_intent", "big_attack_intent", "defend_intent"]
		Enemy.Type.TANK1:
			possibility = ["attack_intent", "buff_self_intent", "defend_intent"]
		Enemy.Type.BUFFER1:
			possibility = ["attack_intent", "buff_self_intent", "defend_intent", "buff_others_intent"]
		Enemy.Type.DEBUFFER1:
			possibility = ["attack_intent", "debuff_intent", "defend_intent"]
		Enemy.Type.ELITE1:
			possibility = ["attack_intent", "big_attack_intent", "defend_intent", "debuff_intent"] ## + charged
		Enemy.Type.BOSS1:
			possibility = ["attack_intent", "big_attack_intent", "defend_intent", "buff_self_intent", "buff_others_intent"] ## + charged
		_:
			pass
	var roll = randi_range(0, possibility.size() - 1)
	call(possibility[roll])

func attack_intent() :
	intent_icon.texture = preload("res://icon.svg")
	var hits = randi_range(1, 5)
	value = [hits, randi_range(8, 24) / hits, "damage"]
	intent_value = str(value[0], " x ", value[1])
func big_attack_intent() :
	intent_icon.texture = preload("res://icon.svg")
	var hits = randi_range(1, 3)
	value = [hits, randi_range(16, 36) / hits, "damage"]
	intent_value = str(value[0], " x ", value[1])
func defend_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(8, 24), "defence"]
	intent_value = str(value[1])
func buff_self_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "buff_self"]
	intent_value = ""
func buff_others_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "buff_others"]
	intent_value = ""
func debuff_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "debuff"]
	intent_value = ""

func use_intents(order : int) :
	match value[2] :
		"damage" :
			player_dmg_number.text = str(value[1])
			for hits in value[0] :
				Singleton.hero_health -= value[1]
				hud.update_hero_health()
				player_dmg_number.get_child(0).play("damage_number_anim")
				await get_tree().create_timer(0.2).timeout
		"defence" :
			pass
		"buff_self" :
			pass
		"buff_others" :
			pass
		"debuff" :
			pass
	self.visible = false
