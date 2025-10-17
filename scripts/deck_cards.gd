extends Node2D

const HAND_CARD = preload("res://scenes/hand_card.tscn")
var scroll_speed = 20
var height : int
var offset_bottom := 0

func cards_grid_initiate(deck_type : int) : ## a bug happening here (1 card spawns to the side, it shouldn't even exist)
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
	height = (get_child_count() / 4) * 194

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up") :
		position.y -= scroll_speed
	elif event.is_action_pressed("scroll_down") :
		position.y += scroll_speed
	
	position.y = clamp(position.y, 0, height - offset_bottom)
