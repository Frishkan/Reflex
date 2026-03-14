extends Node2D

var global_card_stats : Array
var counter := 0
var hits := 0
var misses := 0
const GUITAR_HIT = preload("res://scenes/guitar_hit.tscn")

@onready var container : Node2D = $HitsContainer
@onready var area_a : Area2D = $InputAreaA
@onready var area_s : Area2D = $InputAreaS
@onready var area_d : Area2D = $InputAreaD
@onready var area_f : Area2D = $InputAreaF

func start(card_stats : Array) :
	global_card_stats = card_stats
	for max_hits in global_card_stats[0] :
		var roll := randi_range(0, 3)
		var hit_instance = GUITAR_HIT.instantiate()
		hit_instance.speed = global_card_stats[1]
		hit_instance.position = Vector2(50 + roll * 100, -10)
		container.add_child(hit_instance)
		await get_tree().create_timer(global_card_stats[1] * 0.001 + 0.2).timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a") :
		if container.get_child(0).currently_in_area_a :
			container.get_child(0).queue_free()
			hits += 1
			blink(area_a)
		else :
			misses += 1
	elif event.is_action_pressed("s") :
		if container.get_child(0).currently_in_area_s :
			container.get_child(0).queue_free()
			hits += 1
			blink(area_s)
		else :
			misses += 1
	elif event.is_action_pressed("d") :
		if container.get_child(0).currently_in_area_d :
			container.get_child(0).queue_free()
			hits += 1
			blink(area_d)
		else :
			misses += 1
	elif event.is_action_pressed("f") :
		if container.get_child(0).currently_in_area_f :
			container.get_child(0).queue_free()
			hits += 1
			blink(area_f)
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
	if container.get_child_count() <= 1 && counter == global_card_stats[0]:
		var effect_strenght = [hits, misses]
		CardsLibrary.effect_strenght = effect_strenght
		Events.qte_ended.emit()
		get_parent().qte_active = false
		queue_free()

func blink(area : Area2D) :
	area.modulate = "fea09388"
	await get_tree().create_timer(0.1).timeout
	area.modulate = "ffffff"
