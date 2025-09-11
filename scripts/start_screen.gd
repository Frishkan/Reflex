extends Node2D

@export var no_save := true

func _ready() -> void: 
	if no_save :
		$start.text = "Start"
	else :
		$start.text = "Continue"

func _on_start_pressed() -> void:
	if no_save :
		get_tree().change_scene_to_file("res://scenes/character_screen.tscn")
	else : 
		pass ## open save file

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	pass # Replace with function body.
