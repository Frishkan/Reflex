extends Node2D

var upgrading := false

func _on_deck_button_toggled(toggled_on: bool) -> void:
	open_deck(0, toggled_on, false)

func _on_discarded_cards_button_toggled(toggled_on: bool) -> void:
	open_deck(1, toggled_on, false)

func open_deck(deck_type : int, toggled_on : bool, outer_upgrading : bool) :
	if toggled_on :
		$Deck/DeckCards.visible = toggled_on
		$Deck/Panel.visible = toggled_on
		$Deck/DeckCards.cards_grid_initiate(deck_type)
		if outer_upgrading :
			upgrading = true
	else :
		$Deck/DeckCards.visible = toggled_on
		$Deck/Panel.visible = toggled_on
		for card in $Deck/DeckCards.get_child_count() - 1 :
			$Deck/DeckCards.get_child(card + 1).queue_free()

func _on_menu_pressed():
	get_tree().paused = true
	self.hide()
	$/root/game/FightScene.hide()
	$/root/game/menu.show()

func update_hero_health() :
	$Health/HeroHealthBar.max_value = Singleton.hero_max_health
	$Health/HeroHealthBar.value = Singleton.hero_health
	$Health/HeroHealthNumber.text = str(Singleton.hero_health) + " / " + str(Singleton.hero_max_health)

func update_hero_defence() :
	if Singleton.hero_defence > 0 :
		$Health/HeroDefence.visible = true
		$Health/HeroDefenceNumber.text = str(Singleton.hero_defence)
		$Health/HeroDefenceNumber.visible = true
	else :
		$Health/HeroDefence.visible = false
		$Health/HeroDefenceNumber.visible = false
