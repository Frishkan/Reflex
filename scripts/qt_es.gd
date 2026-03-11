extends Node2D

const KNIFE_QTE = preload("res://scenes/knife_qte.tscn")
const GUITAR_HERO_QTE = preload("res://scenes/guitar_hero_qte.tscn")
const TIMING_CIRCLE_QTE = preload("res://scenes/timing_circle_qte.tscn")
const GUITAR_QTE = preload("res://scenes/guitar.tscn")
var qte_active := false

func knife(card_stats : Array): ## [speed, amount of hits]
	qte_active = true
	var knife_qte = KNIFE_QTE.instantiate()
	add_child(knife_qte)
	knife_qte.start(card_stats)

func guitar_hero(card_stats : Array) : ## [speed, amount of hits]
	qte_active = true
	var guitar_hero_qte = GUITAR_HERO_QTE.instantiate()
	guitar_hero_qte.position = Vector2(-130, -100)
	add_child(guitar_hero_qte)
	guitar_hero_qte.start(card_stats)

func timing_circle(card_stats : Array) : ## [speed, amount of hits, amount of cycles]
	qte_active = true
	var timing_circle_qte = TIMING_CIRCLE_QTE.instantiate()
	timing_circle_qte.position = Vector2(-130, -100)
	add_child(timing_circle_qte)
	timing_circle_qte.start(card_stats)

func guitar(card_stats : Array) : ## [speed, chords, hits per chord]
	qte_active = true
	var guitar_qte = GUITAR_QTE.instantiate()
	guitar_qte.position = Vector2(-130, -100)
	add_child(guitar_qte)
	guitar_qte.start(card_stats)
