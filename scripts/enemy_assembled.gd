class_name EnemyAssembled
extends Node2D


@onready var sprite_2d : Sprite2D = $Visuals/Sprite2D


var index : int

const ICONS := {
	Enemy.Type.ATTACKER1: [preload("res://icon.svg"), Vector2(1, 1)],
	Enemy.Type.TANK1: [preload("res://icon.svg"), Vector2(1, 1)],
	Enemy.Type.BUFFER1: [preload("res://icon.svg"), Vector2(1, 1)],
	Enemy.Type.DEBUFFER1: [preload("res://icon.svg"), Vector2(1, 1)],
	Enemy.Type.ELITE1: [preload("res://icon.svg"), Vector2(1, 1)],
	Enemy.Type.BOSS1: [preload("res://icon.svg"), Vector2(1, 1)]
}

func _ready() -> void:
	pass

func set_enemy(new_enemy_type: Enemy.Type) :
	self.position = Vector2(400 + 200 * (index + 1), 500)
	sprite_2d.texture = ICONS[new_enemy_type][0]
	self.scale = ICONS[new_enemy_type][1]
