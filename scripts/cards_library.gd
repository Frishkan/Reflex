extends Node

## The main place to add cards to, you also have to include their name in res://custom_resources/card.gd.

func character_choosen() : ## starter cards, [Card.Name, upgraded : int]
	match Singleton.character : 
		1: 
			Singleton.deck[0] = [[Card.Name.KNIFE, 0], [Card.Name.DEFENSE, 1], [Card.Name.SOLO, 1], [Card.Name.SKILLFULL_BARRAGE, 0], [Card.Name.ENRAGE, 0]]
		2:
			Singleton.deck[0] = [[Card.Name.KNIFE, 0], [Card.Name.KNIFE, 0], [Card.Name.KNIFE, 0], [Card.Name.SKILLFULL_BARRAGE, 0]]
		3:
			Singleton.deck[0] = [[Card.Name.FIREBALL, 0], [Card.Name.KNIFE, 0], [Card.Name.KNIFE, 0], [Card.Name.SKILLFULL_BARRAGE, 0]]
		4:
			Singleton.deck[0] = [[Card.Name.KNIFE, 0], [Card.Name.KNIFE, 0], [Card.Name.KNIFE, 0], [Card.Name.SKILLFULL_BARRAGE, 0]]

## card info, stats 
const ICONS := { ## NAME[preload(texture), Vector2(scale), "name", "short description", "long description", preload(QTE_icon)]
	Card.Name.KNIFE: [preload("res://textures/knife_card.png"), Vector2(1, 1), "Knife", "Deals ok damage, has no miss penalty. Uses knife QTE.", preload("res://icon.svg")],
	Card.Name.SKILLFULL_BARRAGE: [preload("res://icon.svg"), Vector2(1, 1), "Skillfull barrage", "Deals massive damage, but has big miss penalty. Uses guitar hero QTE.", preload("res://icon.svg")],
	Card.Name.DEFENSE: [preload("res://icon.svg"), Vector2(1, 1), "Defence", "Gain defence.", preload("res://icon.svg")],
	Card.Name.FIREBALL: [preload("res://icon.svg"), Vector2(1, 1), "Fireball", "Damage an enemy and inflict burn. Uses guitar hero QTE.", preload("res://icon.svg")],
	Card.Name.SOLO: [preload("res://icon.svg"), Vector2(1, 1), "Solo", "Damages and confuses all enemies. Uses guitar QTE.", preload("res://icon.svg")],
	Card.Name.ENRAGE: [preload("res://icon.svg"), Vector2(1, 1), "Enrage", "Gives you strenght. Uses evade QTE.", preload("res://icon.svg")],
}

const STATS := { ## NAME[base[effect, hits, miss_penalty, speed], upgrade[effect, hits, miss_penalty, speed], "special effects", needs_choosing]
	Card.Name.KNIFE: [[20, 5, 0, 300], [2, 7, 0, 300], "DEBUGGING", 1], ## 10X damage
	Card.Name.SKILLFULL_BARRAGE: [[4, 8, 2, 400], [6, 10, 2, 400], "", 1],
	Card.Name.DEFENSE: [[8, 0, 0, 0], [10, 0, 0, 0], "Defense", 0],
	Card.Name.FIREBALL: [[2, 12, 0, 400], [3, 12, 0, 400], "Ignite", 1],
	Card.Name.SOLO: [[1, 2, 4, 200], [2, 2, 4, 200], "AOE Confuse", 0], ## uses guitar, miss_penalty = chords
	Card.Name.ENRAGE: [[3, 10, 10, 50], [2, 2, 4, 200], "Strenght", 0], ## uses evade, miss_penalty = barriers, hits = time
}

const FUNCTIONS := {
	Card.Name.KNIFE: ["knife"],
	Card.Name.SKILLFULL_BARRAGE: ["skillfull_barrage"],
	Card.Name.DEFENSE: ["defense"],
	Card.Name.FIREBALL: ["fireball"],
	Card.Name.SOLO: ["solo"],
	Card.Name.ENRAGE: ["enrage"],
}

## Card :
## $/root/game/FightScene/QTEs.qte([max hits, speed]) !!-NOT ALWAYS-!!, is dependant on QTE
## await Events.qte_ended
## damage()/defend()/heal()/buff()/debuff()/special() <- (effect_strenght[hits, misses])

var effect_strenght : Array ## [hits : int, misses : int]

func knife(upgraded : int) : 
	var carray = STATS[Card.Name.KNIFE][upgraded]
	$/root/game/FightScene/QTEs.knife([carray[1], carray[3]])
	await Events.qte_ended
	$/root/game/FightScene.damage(effect_strenght[0] * carray[0])

func skillfull_barrage(upgraded : int) : 
	var carray = STATS[Card.Name.SKILLFULL_BARRAGE][upgraded]
	$/root/game/FightScene/QTEs.guitar_hero([carray[1], carray[3]])
	await Events.qte_ended
	$/root/game/FightScene.damage(effect_strenght[0] * carray[0] - effect_strenght[1] * carray[2])

func defense(upgraded : int) :
	var carray = STATS[Card.Name.DEFENSE][upgraded]
	$/root/game/FightScene.defend(carray[0])

func fireball(upgraded : int) :
	var carray = STATS[Card.Name.FIREBALL][upgraded]
	$/root/game/FightScene/QTEs.guitar_hero([carray[1], carray[3]])
	await Events.qte_ended
	$/root/game/FightScene.damage(effect_strenght[0] * carray[0] - effect_strenght[1] * carray[2])
	$/root/game/FightScene.debuff("burn", 4) 

func solo(upgraded : int) :
	var carray = STATS[Card.Name.SOLO][upgraded]
	$/root/game/FightScene/QTEs.guitar([carray[3], carray[2], carray[1]])
	await Events.qte_ended
	$/root/game/FightScene.damage_all(effect_strenght[0] * carray[0] - effect_strenght[1] * 2)
	$/root/game/FightScene.debuff_all("confuse", 1) 

func enrage(upgraded : int) :
	var carray = STATS[Card.Name.ENRAGE][upgraded]
	$/root/game/FightScene/QTEs.evade([carray[3], carray[1], carray[2]])
	await Events.qte_ended
	$/root/game/FightScene.damage_all(effect_strenght[0] * carray[0] - effect_strenght[1])
	$/root/game/FightScene.add_effect("strenght", 3) 
	$/root/game/FightScene.add_effect("weak", 3) 
