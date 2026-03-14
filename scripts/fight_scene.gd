class_name FightScene
extends Node2D

const REWARDS = preload("res://scenes/rewards.tscn")

@onready var enemies_node : Node2D = %Enemies
@onready var hero_sprite : Sprite2D = $Hero/Sprite2D
@onready var hud : Node2D = $/root/game/hud
@onready var cards : Node2D = $/root/game/hud/Hand/Cards
@onready var hand : Node2D = $/root/game/hud/Hand
@onready var qtes : Node2D = $QTEs

var exited_by_button = false
var room_type : Room.Type
var effect_strenght : Array
var turn_endable := true
var choosen_enemy : int = 0

func _ready() -> void:
	Events.card_played.connect(_card_played)
	Events.enemy_turn_ended.connect(_enemy_turn_ended)
	hand.redraw(Singleton.cards_count_in_hand_per_draw)
	match Singleton.character :
		1 :
			hero_sprite.texture = preload("res://textures/character_1.png")
		2 :
			hero_sprite.texture = preload("res://textures/character_1.png")
		3 :
			hero_sprite.texture = preload("res://textures/character_1.png")
		4 :
			hero_sprite.texture = preload("res://textures/character_1.png")

func _card_played(hand_card : HandCard) :
	CardsLibrary.call(CardsLibrary.FUNCTIONS[hand_card.hand_card_name][0], hand_card.upgraded)

func _on_enemies_child_exiting_tree(_node: Node) -> void:
	if !exited_by_button :
		Singleton.run_enemies += 1
		if enemies_node.get_child_count() == 1 : 
			var rewards_scene = REWARDS.instantiate()
			rewards_scene.start(room_type)
			add_child.call_deferred(rewards_scene)
	exited_by_button = false

func damage(result : int) :
	enemies_node.get_children()[choosen_enemy].update_defence(result * -1)

func damage_all(result : int) :
	for enemy in enemies_node.get_children() :
		enemy.update_defence(result * -1)

func defend(result : int) :
	Singleton.hero_defence += result
	hud.update_hero_defence()

func debuff(type : int, turns : int) : ## 0=weak,1=vulneruble,2=burn,3=poison,4=confuse
	pass

func _on_end_turn_button_pressed() -> void:
	if turn_endable && !qtes.qte_active :
		turn_endable = false
		for card in Singleton.deck[3] :
			print(Singleton.deck)
			Singleton.deck[1].append(card)
		Singleton.deck[3].clear()
		for card in cards.get_children() :
			card.queue_free()
			await get_tree().create_timer(0.1).timeout
		Events.turn_ended.emit()

func _enemy_turn_ended() :
	turn_endable = true
