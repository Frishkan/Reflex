class_name FightScene
extends Node2D

const REWARDS = preload("res://scenes/rewards.tscn")

@onready var enemies_node : Node2D = %Enemies

var exited_by_button = false
var room_type : Room.Type
var effect_strenght : Array
var hero_defence : int = 0

const FUNCTIONS := {
	Card.Name.KNIFE: ["knife"], ##  card function call
	Card.Name.SKILLFULL_BARRAGE: ["skillfull_barrage"],
	Card.Name.DEFENCE: ["defence"],
	Card.Name.FIREBALL: ["fireball"],
	Card.Name.SOLO: ["solo"],
}

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
	self.call(FUNCTIONS[hand_card.hand_card_name][0])

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

## Card :
## $QTEs.card([max hits, speed]) !!-NOT ALWAYS-!!
## await Events.qte_ended
## damage()/defend()/heal()/buff()/debuff()/special() <- (effect_strenght[hits, misses])

## adding cards happens mainly here, but also : res://custom_resources/card.gd, res://scripts/hand_card.gd, 
## and to add as part of the staring deck : res://scripts/character_choosing.gd

func knife() : 
	$QTEs.knife([5, 300])
	await Events.qte_ended
	damage(effect_strenght[0] * 20) ## originally 5

func skillfull_barrage() : 
	$QTEs.guitar_hero([10, 400])
	await Events.qte_ended
	damage(effect_strenght[0] * 4 - effect_strenght[1] * 2)

func defence() :
	defend(8)

func fireball() :
	$QTEs.guitar_hero([8, 400])
	await Events.qte_ended
	damage(effect_strenght[0] * 6 - effect_strenght[1] * 2)
	debuff(2, 4) ## burn

func solo() :
	$QTEs.guitar([400, 4, 2])
	await Events.qte_ended
	damage(effect_strenght[0] * 6 - effect_strenght[1] * 2)
	debuff(5, 1) ## confuse
