extends Node2D


const HAND_CARD = preload("res://scenes/hand_card.tscn")
@onready var cards : Node2D = %Cards

func _ready() -> void:
	Events.card_played.connect(_card_played)
	Events.enemy_turn_ended.connect(redraw)

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
			await get_tree().create_timer(0.001).timeout
	elif Singleton.deck[0].size() < count && Singleton.deck[1].size() >= count + Singleton.deck[0].size():
		for cards in Singleton.deck[0].size() :
			draw(choose_random_card(0))
			await get_tree().create_timer(0.001).timeout
		var remainder = Singleton.cards_count_in_hand_per_draw - Singleton.deck[0].size()
		shuffle()
		Singleton.deck[1].clear()
		for cards in remainder :
			draw(choose_random_card(0))
			await get_tree().create_timer(0.001).timeout
	## enough cards to draw
	else :
		for cards in Singleton.cards_count_in_hand_per_draw :
			draw(choose_random_card(0))
			await get_tree().create_timer(0.001).timeout

func draw(card_index : int) :
	if cards.get_child_count() == 12 :
		pass
	else :
		Singleton.deck[3].append(Singleton.deck[0][card_index]) ## copies card from unplayed to hand
		var new_card := Card.new()
		new_card.name = Singleton.deck[0][card_index]
		Singleton.deck[0].remove_at(card_index) 
		card_picked_up(new_card)
		get_parent().get_child(4).get_child(2).text = str(Singleton.deck[0].size())

func shuffle() :
	for cards in Singleton.deck[1].size() :
		Singleton.deck[0].append(Singleton.deck[1][cards])

func _on_end_turn_button_pressed() -> void:
	Singleton.deck[1].append_array(Singleton.deck[3])
	for card in cards.get_child_count() :
		cards.get_child(card).queue_free()
	Events.turn_ended.emit()
