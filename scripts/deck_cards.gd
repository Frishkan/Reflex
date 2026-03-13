extends Node2D

const HAND_CARD = preload("res://scenes/hand_card.tscn")
var scroll_speed = 20
var height : int
var offset_bottom := 0
var card_sizes : Array = [130, 194] ## [width, height]

func cards_grid_initiate(deck_type : int) :
	var index := 0
	for card in Singleton.deck[deck_type] :
		var new_card = HAND_CARD.instantiate() as Control
		self.add_child(new_card)
		new_card.is_usable_in_hand = false
		new_card.sprite_2d.texture = CardsLibrary.ICONS[card[0]][0]
		new_card.name_label.text = CardsLibrary.ICONS[card[0]][2]
		new_card.short_desc.text = CardsLibrary.ICONS[card[0]][3] ## long desc
		new_card.short_desc.label_settings.font_size = 5
		new_card.scale = CardsLibrary.ICONS[card[0]][1]
		new_card.hand_card_name = card[0]
		new_card.index = index
		new_card.position = Vector2((index % 4) * card_sizes[0] + 124, (index / 4) * card_sizes[1] + 10)
		index += 1
	height = (get_child_count() / 4) * card_sizes[1]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up") :
		position.y -= scroll_speed
	elif event.is_action_pressed("scroll_down") :
		position.y += scroll_speed
	
	position.y = clamp(position.y, 0, height - offset_bottom)
