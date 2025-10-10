extends Node2D

var possibility : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_turn_ended.connect(show_intents)
	show_intents()

func show_intents() :
	generate_intents_by_type()

func generate_intents_by_type() :
	match get_parent().type : 
		Enemy.Type.ATTACKER1:
			possibility = ["attack", "big_attack", "defend"]
		Enemy.Type.TANK1:
			possibility = ["attack", "buff_self", "defend"]
		Enemy.Type.BUFFER1:
			possibility = ["attack", "buff_self", "defend", "buff_others"]
		Enemy.Type.DEBUFFER1:
			possibility = ["attack", "debuff", "defend"]
		Enemy.Type.ELITE1:
			possibility = ["attack", "big_attack", "defend", "debuff"] ## + charged
		Enemy.Type.BOSS1:
			possibility = ["attack", "big_attack", "defend", "buff_self", "buff_others"] ## + charged
		_:
			pass
	var roll = randi_range(0, possibility.size() - 1)
	call(possibility[roll])

func attack() :
	pass
func big_attack() :
	pass
func defend() :
	pass
func buff_self() :
	pass
func buff_others() :
	pass
func debuff() :
	pass
