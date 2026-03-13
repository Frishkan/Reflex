extends Control

var gold := 0
var experience := 0
var card := false
var item := Item
## card_pools[class 0-4, 0=no class][rarity 0-2][[card, upgraded 0/1] 0-...]
var card_pools = [
	[[],[],[]],
	[[[Card.Name.KNIFE, 0], [Card.Name.SKILLFULL_BARRAGE, 0]],[],[]],
	[[],[],[]],
	[[],[],[]],
	[[],[],[]]
]

var weights := [1000, 250, 100]

func _on_button_pressed() -> void:
	Singleton.run_gold += gold
	Singleton.run_exp += experience
	$"/root/game/hud/Gold/GoldNumber".text = str(Singleton.run_gold)
	if card :
		return ## this is kind bugged too
		for i in 3 :
			get_random_card_from_pool(Singleton.character)
	queue_free()

func add_card_to_deck(new_card : Card.Name) :
	Singleton.deck[0].append(new_card)

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
