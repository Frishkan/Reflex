extends CharacterBody2D

var speed = 0

var currently_in_area_a := false
var currently_in_area_s := false
var currently_in_area_d := false
var currently_in_area_f := false

func _ready() -> void:
	get_parent().get_parent().counter += 1

func _physics_process(delta: float) -> void:
	translate(Vector2(0, speed * delta))
	if position.y >= 410 :
		
		queue_free()
