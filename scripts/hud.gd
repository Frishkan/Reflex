extends Node2D

@onready var deck_cards : Node2D = $Deck/DeckCards
@onready var dark_screen : Panel = $Deck/Panel
@onready var menu : Node2D = $/root/game/menu
@onready var hp_bar : TextureProgressBar = $Health/HeroHealthBar
@onready var hp_num : Label = $Health/HeroHealthNumber
@onready var def : Sprite2D = $Health/HeroDefense
@onready var def_num : Label = $Health/HeroDefenseNumber
@onready var unplayed_button : Button = $Deck/DeckButton
@onready var played_button : Button = $Deck/DiscardedCardsButton
@onready var hero_effects_grid : GridContainer = $Health/HeroEffects

@onready var EFFECT_ITEM := preload("res://scenes/effect.tscn")

var upgrading := false

func _on_deck_button_toggled(toggled_on: bool) -> void:
	if toggled_on :
		unplayed_button.z_index = 3
	else :
		unplayed_button.z_index = 0
	open_deck(0, toggled_on, false)

func _on_discarded_cards_button_toggled(toggled_on: bool) -> void:
	if toggled_on :
		played_button.z_index = 3
	else :
		played_button.z_index = 0
	open_deck(1, toggled_on, false)

func open_deck(deck_type : int, toggled_on : bool, outer_upgrading : bool) :
	if toggled_on :
		if outer_upgrading :
			upgrading = true
		deck_cards.visible = toggled_on
		dark_screen.visible = toggled_on
		deck_cards.cards_grid_initiate(deck_type)
	else :
		deck_cards.visible = toggled_on
		dark_screen.visible = toggled_on
		for card in deck_cards.get_children() :
			card.queue_free()

func _on_menu_pressed():
	get_tree().paused = true
	self.hide()
	$/root/game/FightScene.hide()
	menu.show()

func update_hero_health() :
	hp_bar.max_value = Singleton.hero_max_health
	hp_bar.value = Singleton.hero_health
	hp_num.text = str(Singleton.hero_health) + " / " + str(Singleton.hero_max_health)

func update_hero_defense() :
	if Singleton.hero_defense > 0 :
		def.visible = true
		def_num.text = str(Singleton.hero_defense)
		def_num.visible = true
	else :
		def.visible = false
		def_num.visible = false

func update_hero_effects() :
	for effect in hero_effects_grid.get_children() :
		effect.queue_free()
	for effect in $/root/game/FightScene.effects.size() :
		if $/root/game/FightScene.effects[effect] != 0 :
			var current_effect_item = EFFECT_ITEM.instantiate() as Control
			match effect :
				0 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				1 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				2 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				3 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				4 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				5 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				6 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				7 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
			current_effect_item.get_child(1).text = str($/root/game/FightScene.effects[effect])
			hero_effects_grid.add_child(current_effect_item)
