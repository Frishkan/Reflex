extends Node2D

var inside := false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	inside = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") && inside:
		get_parent().value += 1
		queue_free()


func _on_tree_exited() -> void:
	Events.circle_qte_hit.emit()
