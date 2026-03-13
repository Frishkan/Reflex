extends Node2D

var radius = 72.5
var offset = Vector2(75.0, 75.0)
var time_elapsed : float
var value := 0
var local_card_stats : Array ## [speed, hits per cycle, cycles]
var hit_rand_pos : float

@onready var HIT = preload("res://scenes/timing_circle_hit.tscn")
@onready var dot : CharacterBody2D = $Dot

func start(card_stats : Array) -> void:
	local_card_stats = card_stats
	for cycles in local_card_stats[2] :
		for hits in local_card_stats[1] :
			var hit = HIT.instantiate()
			add_child(hit)
			hit_rand_pos = randf_range(-1, 1)
			hit.position = Vector2(sin(hit_rand_pos * PI) * radius, cos(hit_rand_pos * PI) * radius) + offset
			hit.look_at(offset)
		for hits in local_card_stats[1] :
			await Events.circle_qte_hit


func _process(delta: float) -> void:
	time_elapsed += delta
	dot.position = Vector2(sin(time_elapsed * local_card_stats[0]) * radius, cos(time_elapsed * local_card_stats[0]) * radius) + offset

func _on_hits_container_child_exiting_tree(_node: Node) -> void:
	if get_child_count() <= 3 :
		var effect_strenght = [value, time_elapsed - (local_card_stats[2] * 2)]
		CardsLibrary.effect_strenght = effect_strenght
		Events.qte_ended.emit()
		get_parent().qte_active = false
		queue_free()
