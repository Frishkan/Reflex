extends Node2D

var global_card_stats : Array ## [speed, chords, hits per chord]
var counter := 0
var hits = 0
var misses = 0
const GUITAR_HIT = preload("res://scenes/guitar_direction.tscn")

var up := 0
var down := 0
var body_type : int ## 0 = pause, 1 = up, 2 = down
var chord : int = 0
var random_chord := 0
@onready var entered_hit : Node2D = $AntiCrash


#func _ready() -> void: ## testing
	#start([200, 2, 3])

func start(card_stats : Array) :
	global_card_stats = card_stats
	for chords in global_card_stats[1] :
		for hits_per_chord in global_card_stats[2] :
			var hit_instance = GUITAR_HIT.instantiate()
			hit_instance.speed = global_card_stats[0]
			hit_instance.position = Vector2(1, 1)
			$HitsContainer.add_child(hit_instance)
			counter += 1
			await get_tree().create_timer(global_card_stats[0] * 0.003 + 0.2).timeout
		random_chord = randi_range(0, 3)

func _on_up_mouse_entered() -> void:
	if (up > 0) && (chord == entered_hit.chord) && (entered_hit.type == 1) && not entered_hit.hit :
		hits += 1.2
		entered_hit.modulate.a = 0.5
		entered_hit.hit = true
	else : 
		down = 1
		misses += 0.1
	await get_tree().create_timer(0.4).timeout
	down = 0

func _on_down_mouse_entered() -> void:
	if (down > 0) && (chord == entered_hit.chord) && (entered_hit.type == 2) && not entered_hit.hit :
		hits += 1.2
		entered_hit.modulate.a = 0.5
		entered_hit.hit = true
	else : 
		up = 1
		misses += 0.1
	await get_tree().create_timer(0.4).timeout
	up = 0


func _on_detection_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	entered_hit = body.get_parent()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a") :
		chord = 0
		$Label.text = "Am"
	if event.is_action_pressed("s") :
		chord = 1
		$Label.text = "S"
	if event.is_action_pressed("d") :
		chord = 2
		$Label.text = "Dm"
	if event.is_action_pressed("f") :
		chord = 3
		$Label.text = "F"
	if event.is_action_pressed("space") && entered_hit.type == 0:
		hits += 1
		entered_hit.modulate.a = 0.5

func _on_hits_container_child_exiting_tree(node: Node) -> void:
	if $HitsContainer.get_child_count() <= 1 :
		var effect_strenght = [hits, misses]
		get_parent().get_parent().effect_strenght = effect_strenght
		Events.qte_ended.emit()
		get_parent().qte_active = false
		queue_free()
