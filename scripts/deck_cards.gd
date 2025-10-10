extends Node2D

const HAND_CARD = preload("res://scenes/hand_card.tscn")

func cards_grid_initiate(deck_type : int) :
	for cards in Singleton.deck[deck_type].size() :
		var new_card = HAND_CARD.instantiate() as Control
		self.add_child(new_card)
		new_card.is_usable_in_hand = false
		new_card.sprite_2d.texture = new_card.ICONS[Singleton.deck[deck_type][cards - 1]][0]
		new_card.name_label.text = new_card.ICONS[Singleton.deck[deck_type][cards - 1]][2]
		new_card.short_desc.text = new_card.ICONS[Singleton.deck[deck_type][cards - 1]][4] ## long desc
		new_card.short_desc.label_settings.font_size = 5
		new_card.scale = new_card.ICONS[Singleton.deck[deck_type][cards - 1]][1]
		new_card.hand_card_name = Singleton.deck[deck_type][cards - 1]
		new_card.position = Vector2((cards % 4) * 130 + 124, (cards / 4) * 194 + 10)
