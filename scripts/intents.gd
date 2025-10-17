extends Node2D

var possibility : Array
var value : Array ## [times applied, value for, type]
var order : int

@onready var intent_icon = $IntentSprite2D
@onready var intent_value = $IntentValue
@onready var player_dmg_number = preload("res://scenes/dmg_number.tscn")
@onready var hud = $/root/game/hud
@onready var dmg_number_container = $/root/game/FightScene/Hero/DMGNumberContainer

func start() :
	Events.enemy_turn_ended.connect(show_intents)
	Events.turn_ended.connect(get_order)
	show_intents()

func get_order() :
	if get_parent().get_parent().get_child_count() - 1 == get_parent().index :
		order = 1
	elif get_parent().get_parent().get_child_count() - 2 == get_parent().index :
		order = 2
	else :
		order = 3
	order_queue()


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
			print("matched none (error)")
	var roll = randi_range(0, possibility.size() - 1)
	call(possibility[roll])

func attack_intent() :
	intent_icon.texture = preload("res://icon.svg")
	var hits = randi_range(1, 5)
	value = [hits, randi_range(5, 12) / hits, "damage"]
	if hits != 1 :
		intent_value.text = str(value[0]) + " x " + str(value[1])
	else :
		intent_value.text = str(value[1])
func big_attack_intent() :
	intent_icon.texture = preload("res://icon.svg")
	var hits = randi_range(1, 3)
	value = [hits, randi_range(10, 25) / hits, "damage"]
	if hits != 1 :
		intent_value.text = str(value[0]) + " x " + str(value[1])
	else :
		intent_value.text = str(value[1])
func defend_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(8, 24), "defence"]
	intent_value.text = str(value[1])
func buff_self_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "buff_self"]
	intent_value.text = ""
func buff_others_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "buff_others"]
	intent_value.text = ""
func debuff_intent() :
	intent_icon.texture = preload("res://icon.svg")
	value = [1, randi_range(0, 3), "debuff"]
	intent_value.text = ""

func use_intents() :
	match value[2] :
		"damage" :
			for hits in value[0] : 
				Singleton.hero_health -= value[1]
				hud.update_hero_health()
				var dmg_num = player_dmg_number.instantiate() as DMGNumber ## help (anim doing weird stuff)
				dmg_number_container.add_child(dmg_num)
				dmg_num.start(value[1])
				await get_tree().create_timer(0.5).timeout
		"defence" :
			print("matched defence on use : ", value[1])
		"buff_self" :
			print("matched buff self on use")
		"buff_others" :
			print("matched buff others on use")
		"debuff" :
			print("matched debuff on use")
	await get_tree().create_timer(0.5).timeout
	self.visible = false
	if order == 1 :
		Events.first_enemy_turn_ended.emit()
	elif order == 2 :
		Events.second_enemy_turn_ended.emit()
	elif order == 3 :
		Events.enemy_turn_ended.emit()
	
	if get_parent().get_parent().get_child_count() < 3 && order == 2 :
		Events.enemy_turn_ended.emit()
	if get_parent().get_parent().get_child_count() < 2 && order == 1 :
		Events.enemy_turn_ended.emit()

func order_queue() :
	if order == 1 :
		use_intents()
	elif order == 2 :
		await Events.first_enemy_turn_ended
		use_intents()
	elif order == 3 :
		await Events.second_enemy_turn_ended
		use_intents()
