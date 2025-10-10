extends Node2D

const HIT = preload("res://scenes/knife_hit.tscn")
var counter := 0
var hits := 0
var misses := 0
var global_card_stats : Array


func start(card_stats : Array):
	global_card_stats = card_stats
	for i in card_stats[0] :
		var new_hit = HIT.instantiate()
		new_hit.speed = card_stats[1]
		$HitsContainer.add_child(new_hit)
		await get_tree().create_timer(randf_range(0.3, 1.2)).timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") :
		for hit in $HitsContainer.get_children() :
			if hit.currently_in_area :
				hit.queue_free()
				hits += 1


func _on_hit_area_body_entered(body: CharacterBody2D) -> void:
	body.currently_in_area = true


func _on_hit_area_body_exited(body: CharacterBody2D) -> void:
	body.currently_in_area = false


func _on_hits_container_child_exiting_tree(_node: Node) -> void:
	if $HitsContainer.get_child_count() <= 1 && counter == global_card_stats[0]:
		var effect_strenght = [hits, misses]
		get_parent().get_parent().effect_strenght = effect_strenght
		Events.qte_ended.emit()
		get_parent().qte_active = false
		queue_free()
