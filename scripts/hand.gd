extends Node2D

var turn_endable = true
const HAND_CARD = preload("res://scenes/hand_card.tscn")
@onready var cards : Node2D = %Cards

func _ready() -> void:
	Events.card_played.connect(_card_played)
	Events.enemy_turn_ended.connect(_enemy_turn_ended)

func _enemy_turn_ended() :
	redraw(Singleton.cards_count_in_hand_per_draw)
	turn_endable = true

func card_picked_up(card: Card) :
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

func _card_played(card : HandCard) :
	for hand_card in cards.get_children() :
		if cards.get_children()[cards.get_children().find(card)].index < hand_card.index :
			hand_card.index += -1
	Singleton.deck[1].append(card.hand_card_name)
	$/root/game/hud/Deck/CardsPlayed.text = str(Singleton.deck[1].size())
	Singleton.deck[3].remove_at(card.index - 1)
	Events.card_recalculate.emit()

func choose_random_card(deck_type : int) -> int :
	var roll = randi_range(1, Singleton.deck[deck_type].size())
	return roll - 1

func redraw(count : int) : 
	## not enough cards to draw :
	if Singleton.deck[0].size() + Singleton.deck[1].size() < count:
		for cards in Singleton.deck[0].size() :
			draw(choose_random_card(0))
		shuffle()
		for cards in Singleton.deck[0].size() :
			draw(choose_random_card(0))
	
	elif Singleton.deck[0].size() < count && Singleton.deck[1].size() >= count - Singleton.deck[0].size():
		for cards in Singleton.deck[0].size() :
			draw(choose_random_card(0))
		var remainder = count - Singleton.deck[0].size()
		shuffle()
		for cards in remainder :
			draw(choose_random_card(0))
	## enough cards to draw
	else :
		for cards in count :
			draw(choose_random_card(0))

func draw(card_index : int) : 
	if cards.get_child_count() != 12 :
		Singleton.deck[3].append(Singleton.deck[0][card_index]) ## copies card from unplayed to hand
		var new_card := Card.new()
		new_card.name = Singleton.deck[0][card_index]
		Singleton.deck[0].remove_at(card_index) 
		card_picked_up(new_card)
		$/root/game/hud/Deck/CardsToDraw.text = str(Singleton.deck[0].size())
		await get_tree().create_timer(0.001).timeout

func shuffle() : 
	for cards in Singleton.deck[1].size() :
		Singleton.deck[0].append(Singleton.deck[1][cards - 1])
	Singleton.deck[1].clear()
	$/root/game/hud/Deck/CardsPlayed.text = str(Singleton.deck[1].size())

func _on_end_turn_button_pressed() -> void:
	if turn_endable :
		Singleton.deck[1].append_array(Singleton.deck[3])
		Singleton.deck[3].clear()
		turn_endable = false
		for card in cards.get_child_count() :
			cards.get_child(0).queue_free()
			await get_tree().create_timer(0.1).timeout
		Events.turn_ended.emit()
