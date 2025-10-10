extends Control

var gold := 0
var exp := 0
var card := false
var item := Item
## card_pools[class 0-4, 0=no class][rarity 0-2][card 0-...]
var card_pools = [
	[[],[],[]],
	[[Card.Name.KNIFE, Card.Name.SKILLFULL_BARRAGE],[],[]],
	[[],[],[]],
	[[],[],[]],
	[[],[],[]]
]

var weights := [1000, 250, 100]

func _on_button_pressed() -> void:
	$"/root/Singleton".run_gold += gold
	$"/root/Singleton".run_exp += exp
	$"/root/game/hud/Gold/GoldNumber".text = str($"/root/Singleton".run_gold)
	if card :
		for i in 3 :
			get_random_card_from_pool(Singleton.character)
	
	queue_free()

func add_card_to_deck(card : Card.Name) :
	Singleton.deck[0].append(card)

func get_random_card_from_pool(pool : int) -> Card.Name :
	var total_weight = weights[0] + weights[1] + weights[2]
	var roll := randi_range(0, total_weight)
	if roll < weights[0] + 1 :
		return get_random_card_from_rarity(pool, 0)
	elif roll < weights[1] + 1 :
		return get_random_card_from_rarity(pool, 1)
	elif roll < weights[2] + 1 :
		return get_random_card_from_rarity(pool, 2)
	else :
		print("error on picking weighted card")
		return Card.Name.KNIFE

func get_random_card_from_rarity(pool : int, rarity : int) -> Card.Name :
	var roll = randi_range(1, card_pools[pool][rarity].size())
	return card_pools[pool][rarity][roll - 1]
