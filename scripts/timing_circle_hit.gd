extends Node2D

var inside := false


func _on_area_2d_body_entered(body: Node2D) -> void:
	inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") && inside:
		get_parent().value += 1
		queue_free()
