extends Node2D

func _on_return_pressed() -> void:
	get_tree().paused = false
	self.hide()
	$/root/game/hud.show()
	$/root/game/FightScene.show()
	
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
