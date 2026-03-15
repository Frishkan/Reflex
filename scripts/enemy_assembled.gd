class_name EnemyAssembled
extends Node2D

@onready var fight_scene : Node2D = $/root/game/FightScene
@onready var def_num : Label = $DefenseNumber
@onready var def_sprite : Sprite2D = $Defense
@onready var enemy_sprite : Sprite2D = $Visuals/Sprite2D
@onready var enemy_bar : TextureProgressBar = $EnemyHealthBar
@onready var intents : Node2D = $Intents
@onready var enemy_hp_num : Label = $EnemyHealthNumber
@onready var effect_container : GridContainer = $EffectContainer
@onready var EFFECT_ITEM := preload("res://scenes/effect.tscn")

var index : int
var health : int
var defense : int
var type : Enemy.Type
var effects : Array = [0, 0, 0, 0, 0, 0, 0, 0] ## [weak, voulnerable, burn, poison, strenght, defensive, placeholder, placeholder]

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

func update_defense(value : int) :
	if defense + value <= 0 : ## defense broken
		update_health(health + (defense + value))
		defense = 0
		def_sprite.visible = false
		def_num.visible = false
	else : ## new defense
		defense += value
		def_sprite.visible = true
		def_num.text = str(defense)
		def_num.visible = true

func add_effect(type : String) :
	match type :
		"weak" :
			effects[0] += 1
		"voulnerable" :
			effects[1] += 1
		"burn" :
			effects[2] += 1
		"poison" :
			effects[3] += 1
		"strenght" :
			effects[4] += 1
		"defensive" :
			effects[5] += 1
		"placeholder1" :
			effects[6] += 1
		"placeholder2" :
			effects[7] += 1
	update_effects()

func update_effects() :
	if effect_container.get_child_count() != 0 :
		for child in effect_container.get_children() :
			child.queue_free()
	for effect in effects.size() :
		if effects[effect] != 0 :
			var current_effect_item = EFFECT_ITEM.instantiate() as Control
			match effect : ## adding sprite
				0 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				1 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				2 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				3 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				4 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				5 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				6 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
				7 :
					current_effect_item.get_child(0).texture = preload("res://icon.svg")
			current_effect_item.get_child(1).text = str(effects[effect])
			effect_container.add_child(current_effect_item)

func use_effects() :
	for effect in effects.size() :
		if effects[effect] != 0 :
			match effect : ## the functionality of effects
				0 :
					pass
				1 :
					pass
				2 :
					pass
				3 :
					pass
				4 :
					pass
				5 :
					pass
				6 :
					pass
				7 :
					pass
			effects[effect] -= 1
	update_effects()

func _on_click_detector_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse") :
		fight_scene.choosen_enemy = get_parent().get_children().find(self)
		Events.choosed_enemy_index.emit()
