extends CharacterBody2D

var speed = 0

var currently_in_area := false

func _ready() -> void:
	get_parent().get_parent().counter += 1

func _physics_process(delta: float) -> void:
	translate(Vector2(speed * delta, 0))
	if position.x >= 660 :
		
		queue_free()
