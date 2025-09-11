extends Node2D

var character
signal character_choosen

func _on_character_1_pressed() -> void:
	character = 1
	set_health(80)
	$CharHealth.visible = true
	$confirm.visible = true
	$CharDesc.visible = true
	$CharDesc.text = "placeholder 1"

func _on_character_2_pressed() -> void:
	character = 2
	set_health(80)
	$CharHealth.visible = true
	$confirm.visible = true
	$CharDesc.visible = true
	$CharDesc.text = "placeholder 2"

func _on_character_3_pressed() -> void:
	character = 3
	set_health(60)
	$CharHealth.visible = true
	$confirm.visible = true
	$CharDesc.visible = true
	$CharDesc.text = "placeholder 3"

func _on_character_4_pressed() -> void:
	character = 4
	set_health(70)
	$CharHealth.visible = true
	$confirm.visible = true
	$CharDesc.visible = true
	$CharDesc.text = "placeholder 4"


func _on_confirm_pressed() -> void:
	character_choosen.emit(character)
	$CharHealth.visible = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func set_health(health : int) -> void:
	$CharHealth/HealthBar.max_value = health
	$CharHealth/HealthBar.value = health
	$CharHealth/HealthNumber.text = str($CharHealth/HealthBar.value) + " / " + str($CharHealth/HealthBar.max_value)
