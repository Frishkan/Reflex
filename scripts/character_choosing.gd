extends Node2D

var character : int
var cards_in_hand : int

func _on_character_1_pressed() -> void:
	character = 1
	cards_in_hand = 2
	set_health(80)
	$CharDesc.text = "This guy is quite a metal fan, he uses his guitar skills to progress."

func _on_character_2_pressed() -> void:
	character = 2
	cards_in_hand = 3
	set_health(120)
	$CharDesc.text = "Just a chill guy who went fishing."

func _on_character_3_pressed() -> void:
	character = 3
	cards_in_hand = 4
	set_health(60)
	$CharDesc.text = "Exuplooosion!!! said Megumin calmly... The glass cannon anarhist."

func _on_character_4_pressed() -> void:
	character = 4
	cards_in_hand = 6
	set_health(70)
	$CharDesc.text = "#&C%UR$S%ED#&"


func _on_confirm_pressed() -> void:
	Singleton.character = character
	Singleton.cards_count_in_hand_per_draw = cards_in_hand
	
	match character : ## gives out starter cards
		1: 
			Singleton.deck = [[Card.Name.KNIFE, Card.Name.DEFENCE, Card.Name.SOLO, Card.Name.SKILLFULL_BARRAGE],[],[],[]]
		2:
			Singleton.deck = [[Card.Name.KNIFE, Card.Name.KNIFE, Card.Name.KNIFE, Card.Name.SKILLFULL_BARRAGE],[],[],[]]
		3:
			Singleton.deck = [[Card.Name.FIREBALL, Card.Name.KNIFE, Card.Name.KNIFE, Card.Name.SKILLFULL_BARRAGE],[],[],[]]
		4:
			Singleton.deck = [[Card.Name.KNIFE, Card.Name.KNIFE, Card.Name.KNIFE, Card.Name.SKILLFULL_BARRAGE],[],[],[]]
	
	$/root/game/map.visible = true
	$/root/game/map.start()
	$/root/game/hud.update_hero_health()
	queue_free()

func set_health(health : int) -> void:
	Singleton.hero_health = health
	Singleton.hero_max_health = health
	$CharHealth/HealthBar.max_value = health
	$CharHealth/HealthBar.value = health
	$CharHealth/HealthNumber.text = str($CharHealth/HealthBar.value) + " / " + str($CharHealth/HealthBar.max_value)
	$CharHealth.visible = true
	$confirm.visible = true
	$CharDesc.visible = true
