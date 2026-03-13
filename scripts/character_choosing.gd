extends Node2D

@onready var map : Node2D = $/root/game/map
@onready var hud : Node2D = $/root/game/hud
@onready var desription : Label = $CharDesc
@onready var bar := $CharHealth/HealthBar
@onready var number : Label = $CharHealth/HealthNumber
@onready var hp : Control = $CharHealth
@onready var confirm : Button = $confirm

func _on_character_1_pressed() -> void:
	Singleton.character = 1
	Singleton.cards_count_in_hand_per_draw = 2
	set_health(80)
	desription.text = "This guy is quite a metal fan, he uses his guitar skills to progress."

func _on_character_2_pressed() -> void:
	Singleton.character = 2
	Singleton.cards_count_in_hand_per_draw = 3
	set_health(120)
	desription.text = "Just a chill guy who went fishing."

func _on_character_3_pressed() -> void:
	Singleton.character = 3
	Singleton.cards_count_in_hand_per_draw = 4
	set_health(60)
	desription.text = "Exuplooosion!!! said Megumin calmly... The glass cannon anarhist."

func _on_character_4_pressed() -> void:
	Singleton.character = 4
	Singleton.cards_count_in_hand_per_draw = 6
	set_health(70)
	desription.text = "#&C%UR$S%ED#&"


func _on_confirm_pressed() -> void:
	CardsLibrary.character_choosen()
	map.visible = true
	map.start()
	hud.update_hero_health()
	queue_free()

func set_health(health : int) -> void:
	Singleton.hero_health = health
	Singleton.hero_max_health = health
	bar.max_value = health
	bar.value = health
	number.text = str(health) + " / " + str(health)
	hp.visible = true
	confirm.visible = true
	desription.visible = true
