class_name EnemyAssembled
extends Node2D


@onready var sprite_2d : Sprite2D = $Visuals/Sprite2D
@onready var enemy_health_bar : TextureProgressBar = $EnemyHealthBar
@onready var enemy_health_number : Label = $EnemyHealthNumber


var index : int

const ICONS := {
	Enemy.Type.ATTACKER1: [preload("res://icon.svg"), Vector2(1, 1), 40],
	Enemy.Type.TANK1: [preload("res://icon.svg"), Vector2(1, 1), 200],
	Enemy.Type.BUFFER1: [preload("res://icon.svg"), Vector2(1, 1), 50],
	Enemy.Type.DEBUFFER1: [preload("res://icon.svg"), Vector2(1, 1), 50],
	Enemy.Type.ELITE1: [preload("res://icon.svg"), Vector2(1, 1), 250],
	Enemy.Type.BOSS1: [preload("res://icon.svg"), Vector2(1, 1), 800]
}

func _ready() -> void:
	pass

func set_enemy(new_enemy_type: Enemy.Type) :
	self.position = Vector2(1200 - 150 * (index + 1), 400)
	sprite_2d.texture = ICONS[new_enemy_type][0]
	self.scale = ICONS[new_enemy_type][1]
	enemy_health_bar.max_value = ICONS[new_enemy_type][2]
	update_health(ICONS[new_enemy_type][2])

func update_health(new_health : int) :
	enemy_health_bar.value = new_health
	enemy_health_number.text = str(new_health)
