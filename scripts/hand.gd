extends Node2D


const HAND_CARD = preload("res://scenes/hand_card.tscn")
@onready var cards : Node2D = %Cards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.card_picked_up.connect(_card_picked_up)
	
func _card_picked_up(card: Card) :
	card.position = Vector2(cards.get_child_count() * 50 + 25, 85)
	_spawn_card(card)

func _spawn_card(card : Card) :
	var hand_card = HAND_CARD.instantiate() as HandCard
	cards.add_child(hand_card)
	hand_card.set_item(card)
	hand_card.card = card
