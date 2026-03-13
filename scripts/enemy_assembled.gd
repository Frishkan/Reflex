class_name EnemyAssembled
extends Node2D

@onready var fight_scene : Node2D = $/root/game/FightScene
@onready var def_num : Label = $DefenceNumber
@onready var def_sprite : Sprite2D = $Defence
@onready var enemy_sprite : Sprite2D = $Visuals/Sprite2D
@onready var enemy_bar : TextureProgressBar = $EnemyHealthBar
@onready var intents : Node2D = $Intents
@onready var enemy_hp_num : Label = $EnemyHealthNumber

var index : int
var health : int
var defence : int
var type : Enemy.Type

const ICONS := {
	Enemy.Type.ATTACKER1: [preload("res://icon.svg"), Vector2(1, 1), 40],
	Enemy.Type.TANK1: [preload("res://icon.svg"), Vector2(1, 1), 100],
	Enemy.Type.BUFFER1: [preload("res://icon.svg"), Vector2(1, 1), 50],
	Enemy.Type.DEBUFFER1: [preload("res://icon.svg"), Vector2(1, 1), 50],
	Enemy.Type.ELITE1: [preload("res://icon.svg"), Vector2(1, 1), 250],
	Enemy.Type.BOSS1: [preload("res://icon.svg"), Vector2(1, 1), 800]
}

func set_enemy(new_enemy_type: Enemy.Type) :
	self.position = Vector2(780 - 80 * (index + 1), 275)
	enemy_sprite.texture = ICONS[new_enemy_type][0]
	self.scale = ICONS[new_enemy_type][1]
	enemy_bar.max_value = ICONS[new_enemy_type][2]
	type = new_enemy_type
	update_health(ICONS[new_enemy_type][2])
	intents.start()

func update_health(new_health : int) :
	enemy_bar.value = new_health
	enemy_hp_num.text = str(new_health)
	health = new_health
	if health <= 0 :
		queue_free()

func update_defence(value : int) :
	if defence + value <= 0 : ## defence broken
		update_health(health + (defence + value))
		defence = 0
		def_sprite.visible = false
		def_num.visible = false
	else : ## new defence
		defence += value
		def_sprite.visible = true
		def_num.text = str(defence)
		def_num.visible = true


func _on_click_detector_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse") :
		fight_scene.choosen_enemy = get_parent().get_children().find(self)
		Events.choosed_enemy_index.emit()
