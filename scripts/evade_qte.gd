extends Node2D

@onready var dot : CharacterBody2D = $Dot
@onready var hit_container : Node2D = $HitContainer
@onready var BARRIER := preload("res://scenes/barrier.tscn")
@onready var progress_bar : TextureProgressBar = $ProgressBar
var radius : float = 75
var offset : Vector2 = Vector2(75, 75)
var local_card_stats : Array ## [speed, time, barriers]
var misses : int = 0
var floor_height : float = 10
var fps : int = 20

func _ready() -> void: ## testing
	start([50, 10, 20])

func start(card_stats : Array) -> void:
	local_card_stats = card_stats
	progress_bar.max_value = local_card_stats[1] * fps * 2
	for barriers in local_card_stats[2] :
		var barrier = BARRIER.instantiate()
		var barrier_rand_pos : float = randf_range(-1, 1) ## change this to change the spawn locations
		var barrier_rand_height : int = randi_range(0, 1)
		barrier.position = Vector2(sin(barrier_rand_pos * PI) * (radius + barrier_rand_height * floor_height), cos(barrier_rand_pos * PI) * (radius + barrier_rand_height * floor_height))
		barrier.look_at(offset)
		hit_container.add_child(barrier)
	for seconds in local_card_stats[1] : 
		for i in fps :
			await get_tree().create_timer(1.0 / fps).timeout
			progress_bar.value += 1
	var effect_strenght = [1, misses]
	CardsLibrary.effect_strenght = effect_strenght
	Events.qte_ended.emit()
	get_parent().qte_active = false
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") || event.is_action_pressed("w") :
		dot.position.y = floor_height * 0.5
	if event.is_action_pressed("ui_down") || event.is_action_pressed("s") :
		dot.position.y = floor_height * 1.5
