class_name FightScene
extends Node2D

const REWARDS = preload("res://scenes/rewards.tscn")

@onready var enemies_node : Node2D = %Enemies

var exited_by_button = false
var room_type : Room.Type
var effect_strenght : Array

const FUNCTIONS := {
	Card.Name.KNIFE: ["knife"], ##  card function call
	Card.Name.SKILLFULL_BARRAGE: ["skillfull_barrage"],
}

func _ready() -> void:
	Events.card_played.connect(_card_played)
	get_parent().get_child(0).get_child(1).redraw(Singleton.cards_count_in_hand_per_draw)

func _card_played(hand_card : HandCard) :
	self.call(FUNCTIONS[hand_card.hand_card_name][0])

func _on_enemies_child_exiting_tree(node: Node) -> void:
	if enemies_node.get_child_count() == 1 && !exited_by_button : 
		print(enemies_node.get_child_count())
		var rewards_scene = REWARDS.instantiate()
		rewards_scene.start(room_type)
		add_child(rewards_scene)
	exited_by_button = false

func damage(result : int) :
	enemies_node.get_children()[enemies_node.get_children().size() - 1].change_health(result * -1)

## Card :
## $QTEs.card([max hits, speed])
## await Events.qte_ended
## damage()/defend()/heal()/buff()/debuff()/special() <- (effect_strenght[hits, misses])

func knife() : 
	$QTEs.knife([5, 300])
	await Events.qte_ended
	damage(effect_strenght[0] * 20)

func skillfull_barrage() : 
	$QTEs.guitar_hero([10, 400])
	await Events.qte_ended
	damage(effect_strenght[0] * 4 - effect_strenght[1] * 2)
