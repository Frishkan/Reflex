extends Node2D


func _on_character_screen_character_choosen() -> void:
	update_hero_health()

func _on_deck_button_toggled(toggled_on: bool) -> void:
	open_deck(0, toggled_on)

func _on_discarded_cards_button_toggled(toggled_on: bool) -> void:
	open_deck(1, toggled_on)

func open_deck(deck_type : int, toggled_on : bool) :
	if toggled_on :
		$Deck/DeckCards.visible = toggled_on
		$Deck/Panel.visible = toggled_on
		$Deck/DeckCards.cards_grid_initiate(0)
	else :
		$Deck/DeckCards.visible = toggled_on
		$Deck/Panel.visible = toggled_on
		for card in $Deck/DeckCards.get_child_count() - 1 :
			$Deck/DeckCards.get_child(card + 1).queue_free()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	get_parent().get_child(2).exited_by_button = true

func update_hero_health() :
	$Health/HeroHealthBar.max_value = Singleton.hero_max_health
	$Health/HeroHealthBar.value = Singleton.hero_health
	$Health/HeroHealthNumber.text = str(Singleton.hero_health) + " / " + str(Singleton.hero_max_health)
