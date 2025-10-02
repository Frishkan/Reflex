extends Control

var gold := 0
var exp := 0
var card := false
var item := Item



func _on_button_pressed() -> void:
	$"/root/Singleton".run_gold += gold
	$"/root/Singleton".run_exp += exp
	$"/root/game/hud/Gold/GoldNumber".text = str($"/root/Singleton".run_gold)
	if card :
		pass ## initialise card picking scene
	
	queue_free()
