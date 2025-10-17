extends Node2D

const REWARD_ITEM = preload("res://scenes/reward_item.tscn")

var ICONS := [
	[preload("res://textures/Coin.png"), " coins"],
	[preload("res://icon.svg"), " exp"],
	[preload("res://icon.svg"), "pick a card"]
]

var defeated_room = 0
@export var offset = 40

func start(room : Room.Type) :
	defeated_room = room
	
	var gold = REWARD_ITEM.instantiate()
	gold.position = Vector2(20, 0 * offset)
	gold.gold = randi_range(30, 200)
	gold.get_child(0).icon = ICONS[0][0]
	gold.get_child(0).text = str(gold.gold) + ICONS[0][1]
	$RewardContainer.add_child(gold)
	
	var exp = REWARD_ITEM.instantiate()
	exp.position = Vector2(20, 1 * offset)
	exp.exp = randi_range(10, 400)
	exp.get_child(0).icon = ICONS[1][0]
	exp.get_child(0).text = str(exp.exp) + ICONS[1][1]
	$RewardContainer.add_child(exp)
	
	var card = REWARD_ITEM.instantiate()
	card.position = Vector2(20, 2 * offset)
	card.card = true
	card.get_child(0).icon = ICONS[2][0]
	card.get_child(0).text = ICONS[2][1]
	$RewardContainer.add_child(card)
	
	
	if room ==  5 || room == 6: ## if elite or boss defeated
		var item = REWARD_ITEM.instantiate()
		item.position = Vector2(20, 3 * offset)
		## pick_random_item_from_pool()
		## set_item_stats()
		$RewardContainer.add_child(item)


func _on_continue_button_pressed() -> void:
	if defeated_room == 6 :
		$/root/game/map.generate_new_map()
		$/root/game/map.unlock_floor(0)
	
	$/root/game/map.show_map()
	$/root/game/map.unlock_next_rooms()
	
	$/root/game/hud.visible = false
	
	for i in $/root/game/hud/Hand/Cards.get_child_count() : ## clears memory
		$/root/game/hud/Hand/Cards.get_child(i).queue_free()
	
	$/root/game/FightScene.queue_free()
	queue_free()
