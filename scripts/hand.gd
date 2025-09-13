extends Node2D


const HAND_CARD = preload("res://scenes/hand_card.tscn")
@onready var cards : Node2D = %Cards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.card_picked_up.connect(_card_picked_up)
	

func _card_picked_up(card: Card) :
	_spawn_card(card)
	Events.card_recalculate.emit()

func _spawn_card(card : Card) :
	if cards.get_child_count() == 12 :
		pass
	else :
		var hand_card = HAND_CARD.instantiate() as HandCard
		cards.add_child(hand_card)
		card.index = cards.get_child_count()
		hand_card.set_card(card)
		hand_card.card = card


func _on_button_pressed() -> void:
	var new_card := Card.new()
	new_card.name = Card.Name.KNIFE
	Events.card_picked_up.emit(new_card)
