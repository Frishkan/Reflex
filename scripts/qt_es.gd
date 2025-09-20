extends Node2D

const KNIFE_QTE = preload("res://scenes/knife_qte.tscn")

func knife(card_stats : Array):
	print("initiating knife QTE for ", card_stats)
	var knife_qte = KNIFE_QTE.instantiate()
	add_child(knife_qte)
	knife_qte.start(card_stats)

func guitar_hero(card_stats : Array) :
	print("initiating guitar hero QTE for ", card_stats)
