extends Node2D

var global_card_stats : Array
var counter := 0
var hits := 0
var misses := 0
const GUITAR_HIT = preload("res://scenes/guitar_hit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start(card_stats : Array) :
	global_card_stats = card_stats
	for max_hits in global_card_stats[1] :
		var roll := randi_range(0, 3)
		var hit_instance = GUITAR_HIT.instantiate()
		hit_instance.speed = global_card_stats[2]
		hit_instance.position = Vector2(50 + roll * 100, -10)
		$HitsContainer.add_child(hit_instance)
		await get_tree().create_timer(global_card_stats[2] * 0.001 + 0.2).timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a") :
		if $HitsContainer.get_child(0).currently_in_area_a :
			$HitsContainer.get_child(0).queue_free()
			hits += 1
			blink($InputAreaA)
		else :
			misses += 1
	elif event.is_action_pressed("s") :
		if $HitsContainer.get_child(0).currently_in_area_s :
			$HitsContainer.get_child(0).queue_free()
			hits += 1
			blink($InputAreaS)
		else :
			misses += 1
	elif event.is_action_pressed("d") :
		if $HitsContainer.get_child(0).currently_in_area_d :
			$HitsContainer.get_child(0).queue_free()
			hits += 1
			blink($InputAreaD)
		else :
			misses += 1
	elif event.is_action_pressed("f") :
		if $HitsContainer.get_child(0).currently_in_area_f :
			$HitsContainer.get_child(0).queue_free()
			hits += 1
			blink($InputAreaF)
		else :
			misses += 1


func _on_input_area_a_body_entered(body: CharacterBody2D) -> void:
	body.currently_in_area_a = true

func _on_input_area_a_body_exited(body: CharacterBody2D) -> void:
	body.currently_in_area_a = false


func _on_input_area_s_body_entered(body: CharacterBody2D) -> void:
	body.currently_in_area_s = true

func _on_input_area_s_body_exited(body: CharacterBody2D) -> void:
	body.currently_in_area_s = false


func _on_input_area_d_body_entered(body: CharacterBody2D) -> void:
	body.currently_in_area_d = true

func _on_input_area_d_body_exited(body: CharacterBody2D) -> void:
	body.currently_in_area_d = false


func _on_input_area_f_body_entered(body: CharacterBody2D) -> void:
	body.currently_in_area_f = true

func _on_input_area_f_body_exited(body: CharacterBody2D) -> void:
	body.currently_in_area_f = false


func _on_hits_container_child_exiting_tree(_node: Node) -> void:
	if $HitsContainer.get_child_count() <= 1 && counter == global_card_stats[1]:
		get_parent().get_parent().output((hits * global_card_stats[0] - (global_card_stats[1] - hits + misses) * global_card_stats[3]) * global_card_stats[5], global_card_stats[4])
		get_parent().qte_active = false
		queue_free()

func blink(area : Area2D) :
	area.modulate = "fea09388"
	await get_tree().create_timer(0.1).timeout
	area.modulate = "ffffff"
