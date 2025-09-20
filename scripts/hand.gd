extends Node2D


const HAND_CARD = preload("res://scenes/hand_card.tscn")
@onready var cards : Node2D = %Cards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.card_picked_up.connect(_card_picked_up)
	Events.card_played.connect(_card_played)
	

func _card_picked_up(card: Card) :
	_spawn_card(card)
	Events.card_recalculate.emit()

func _spawn_card(card : Card) :
	if cards.get_child_count() == 12 :
		pass
	else :
		var hand_card = HAND_CARD.instantiate() as Control
		cards.add_child(hand_card)
		card.index = cards.get_child_count()
		hand_card.set_card(card)
		hand_card.card = card

## testing the cards
var i := true
func _on_button_pressed() -> void:
	var new_card := Card.new()
	if i :
		new_card.name = Card.Name.KNIFE
	else :
		new_card.name = Card.Name.SKILLFULL_BARRAGE
	i = !i
	Events.card_picked_up.emit(new_card)
## testing the cards

func _card_played(card : HandCard) :
	for hand_card in cards.get_children() :
		if cards.get_children()[cards.get_children().find(card)].index < hand_card.index :
			hand_card.index += -1
	Events.card_recalculate.emit()
