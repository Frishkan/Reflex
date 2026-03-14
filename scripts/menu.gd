extends Node2D

@onready var hud : Node2D = $/root/game/hud

func _on_return_pressed() -> void:
	get_tree().paused = false
	self.hide()
	hud.show()
	$/root/game/FightScene.show()
