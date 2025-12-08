extends Node2D

var radius = 72.5
var offset = Vector2(75.0, 75.0)
var time_elapsed : float
var value := 0
var local_card_stats : Array = [5.0, 5, 2]## [speed, amount of hits, amount of hits simoltanious]
var hit_rand_pos : float

@onready var HIT = preload("res://scenes/timing_circle_hit.tscn")

func _ready() -> void:
	for hits in local_card_stats[1] :
		var hit = HIT.instantiate()
		add_child(hit)
		hit_rand_pos = randf_range(-1, 1)
		hit.position = Vector2(sin(hit_rand_pos * PI) * radius, cos(hit_rand_pos * PI) * radius) + offset
		hit.look_at(Vector2(75, 75))
		await get_tree().create_timer(1).timeout


func _process(delta: float) -> void:
	time_elapsed += delta
	
	$Dot.position = Vector2(sin(time_elapsed * local_card_stats[0]) * radius, cos(time_elapsed * local_card_stats[0]) * radius) + offset
