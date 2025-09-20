extends Node2D

const KNIFE_QTE = preload("res://scenes/knife_qte.tscn")
var qte_active := false

func knife(card_stats : Array):
	qte_active = true
	var knife_qte = KNIFE_QTE.instantiate()
	add_child(knife_qte)
	knife_qte.start(card_stats)

func guitar_hero(card_stats : Array) :
	print("initiating guitar hero QTE for ", card_stats)
