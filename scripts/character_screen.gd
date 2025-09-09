extends Node2D

var health = 0

func _on_character_screen_character_choosen(character) -> void:
	if character == 1 :
		health = 80
		$Health/HealthBar.max_value = health
		$Health/HealthBar.value = health
		$Health/HealthNumber.text = str($Health/HealthBar.value) + " / " + str($Health/HealthBar.max_value)
	elif character == 2 :
		health = 80
		$Health/HealthBar.max_value = health
		$Health/HealthBar.value = health
		$Health/HealthNumber.text = str($Health/HealthBar.value) + " / " + str($Health/HealthBar.max_value)
	elif character == 3 :
		health = 60
		$Health/HealthBar.max_value = health
		$Health/HealthBar.value = health
		$Health/HealthNumber.text = str($Health/HealthBar.value) + " / " + str($Health/HealthBar.max_value)
	elif character == 4 :
		health = 70
		$Health/HealthBar.max_value = health
		$Health/HealthBar.value = health
		$Health/HealthNumber.text = str($Health/HealthBar.value) + " / " + str($Health/HealthBar.max_value)

func _on_deck_button_toggled(toggled_on: bool) -> void:
	$Deck/DeckCards.visible = toggled_on

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
