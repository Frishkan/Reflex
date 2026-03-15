extends Node2D

@onready var dot : CharacterBody2D = $Dot
@onready var BARRIER := preload("res://scenes/barrier.tscn")

var radius = 72.5
var offset = Vector2(75.0, 75.0)
var local_card_stats : Array ## [speed, time, barriers]
var misses : int = 0

func _ready() -> void: ## testing
	start([5, 10, 3])

func start(card_stats : Array) -> void:
	local_card_stats = card_stats
	for barriers in local_card_stats[2] :
		var barrier = BARRIER.instantiate()
		var barrier_rand_pos : float = randf_range(-1, 1) ## change this to change the spawn locations
		barrier.position = Vector2(sin(barrier_rand_pos * PI) * radius, cos(barrier_rand_pos * PI) * radius) + offset
		barrier.look_at(offset)
		$HitContainer.add_child(barrier)
	await get_tree().create_timer(local_card_stats[1]).timeout
	var effect_strenght = [1, misses]
	CardsLibrary.effect_strenght = effect_strenght
	Events.qte_ended.emit()
	get_parent().qte_active = false
	queue_free()
