extends Node2D

const REWARD_ITEM = preload("res://scenes/reward_item.tscn")

var ICONS := [
	[preload("res://textures/Coin.png"), " coins"],
	[preload("res://icon.svg"), " exp"],
	[preload("res://icon.svg"), "pick a card"]
]

@onready var hud : Node2D = $/root/game/hud
@onready var map : Node2D = $/root/game/map
@onready var cards : Node2D = $/root/game/hud/Hand/Cards
@onready var reward_container : Control = $RewardContainer

var defeated_room = 0
@export var offset = 40

func start(room : Room.Type) :
	defeated_room = room
	
	var gold = REWARD_ITEM.instantiate()
	gold.position = Vector2(20, 0 * offset)
	gold.gold = randi_range(30, 200)
	gold.get_child(0).icon = ICONS[0][0]
	gold.get_child(0).text = str(gold.gold) + ICONS[0][1]
	reward_container.add_child(gold)
	
	var experience = REWARD_ITEM.instantiate()
	experience.position = Vector2(20, 1 * offset)
	experience.experience = randi_range(10, 400)
	experience.get_child(0).icon = ICONS[1][0]
	experience.get_child(0).text = str(experience.experience) + ICONS[1][1]
	reward_container.add_child(experience)
	
	var card = REWARD_ITEM.instantiate()
	card.position = Vector2(20, 2 * offset)
	card.card = true
	card.get_child(0).icon = ICONS[2][0]
	card.get_child(0).text = ICONS[2][1]
	reward_container.add_child(card)
	
	
	if room ==  5 || room == 6: ## if elite or boss defeated
		Singleton.run_elites += 1
		Singleton.run_enemies -= 1
		var item = REWARD_ITEM.instantiate()
		item.position = Vector2(20, 3 * offset)
		## pick_random_item_from_pool()
		## set_item_stats()
		reward_container.add_child(item)


func _on_continue_button_pressed() -> void:
	if defeated_room == 6 :
		map.generate_new_map()
		map.unlock_floor(0)
	map.show_map()
	map.unlock_next_rooms()
	
	hud.visible = false
	
	for card in cards.get_children() : ## clears memory
		card.queue_free()
	$/root/game/FightScene.queue_free()
	queue_free()
