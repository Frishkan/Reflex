extends Node2D

@onready var deck_cards : Node2D = $Deck/DeckCards
@onready var dark_screen : Panel = $Deck/Panel
@onready var menu : Node2D = $/root/game/menu
@onready var hp_bar : TextureProgressBar = $Health/HeroHealthBar
@onready var hp_num : Label = $Health/HeroHealthNumber
@onready var def : Sprite2D = $Health/HeroDefence
@onready var def_num : Label = $Health/HeroDefenceNumber

var upgrading := false

func _on_deck_button_toggled(toggled_on: bool) -> void:
	open_deck(0, toggled_on, false)

func _on_discarded_cards_button_toggled(toggled_on: bool) -> void:
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

func update_hero_defence() :
	if Singleton.hero_defence > 0 :
		def.visible = true
		def_num.text = str(Singleton.hero_defence)
		def_num.visible = true
	else :
		def.visible = false
		def_num.visible = false
