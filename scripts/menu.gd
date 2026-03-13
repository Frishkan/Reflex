extends Node2D

func _on_return_pressed() -> void:
	get_tree().paused = false
	self.hide()
	$/root/game/hud.show()
	$/root/game/FightScene.show()
