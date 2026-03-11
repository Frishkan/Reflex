class_name FightScene
extends Node2D

const REWARDS = preload("res://scenes/rewards.tscn")

@onready var enemies_node : Node2D = %Enemies

var exited_by_button = false
var room_type : Room.Type
var effect_strenght : Array
var hero_defence : int = 0

func _ready() -> void:
	Events.card_played.connect(_card_played)
	get_parent().get_child(0).get_child(1).redraw(Singleton.cards_count_in_hand_per_draw)
	match $/root/Singleton.character :
		1 :
			$Hero/Sprite2D.texture = preload("res://textures/character_1.png")
		2 :
			$Hero/Sprite2D.texture = preload("res://textures/character_1.png")
		3 :
			$Hero/Sprite2D.texture = preload("res://textures/character_1.png")
		4 :
			$Hero/Sprite2D.texture = preload("res://textures/character_1.png")

func _card_played(hand_card : HandCard) :
	CardsLibrary.call(CardsLibrary.FUNCTIONS[hand_card.hand_card_name][0], hand_card.upgraded)

func _on_enemies_child_exiting_tree(node: Node) -> void:
	if !exited_by_button :
		Singleton.run_enemies += 1
		if enemies_node.get_child_count() == 1 : 
			var rewards_scene = REWARDS.instantiate()
			rewards_scene.start(room_type)
			add_child.call_deferred(rewards_scene)
	exited_by_button = false

func damage(result : int) :
	enemies_node.get_children()[enemies_node.get_child_count() - 1].change_health(result * -1)

func damage_all(result : int) :
	for enemy in enemies_node.get_children() :
		enemy.change_health(result * -1)

func defend(result : int) :
	hero_defence += result
	update_hero_defence()

func debuff(type : int, turns : int) : ## 0=weak,1=vulneruble,2=burn,3=poison,4=confuse
	pass

func update_hero_defence() :
	if hero_defence > 0 :
		$/root/game/hud/Health/HeroDefence.visible = true
		$/root/game/hud/Health/HeroDefenceNumber.text = str(hero_defence)
		$/root/game/hud/Health/HeroDefenceNumber.visible = true
	else :
		$/root/game/hud/Health/HeroDefence.visible = false
		$/root/game/hud/Health/HeroDefenceNumber.visible = false
