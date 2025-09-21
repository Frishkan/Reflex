extends Node2D

const KNIFE_QTE = preload("res://scenes/knife_qte.tscn")
const GUITAR_HERO_QTE = preload("res://scenes/guitar_hero_qte.tscn")
var qte_active := false

func knife(card_stats : Array):
	qte_active = true
	var knife_qte = KNIFE_QTE.instantiate()
	add_child(knife_qte)
	knife_qte.start(card_stats)

func guitar_hero(card_stats : Array) :
	qte_active = true
	var guitar_hero_qte = GUITAR_HERO_QTE.instantiate()
	guitar_hero_qte.position = Vector2(-200, -100)
	add_child(guitar_hero_qte)
	guitar_hero_qte.start(card_stats)
