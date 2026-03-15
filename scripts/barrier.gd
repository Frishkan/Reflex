extends Area2D

@onready var parent := get_parent().get_parent()

func _process(delta: float) -> void:
	self.translate(Vector2(0, parent.local_card_stats[0] * delta).rotated(rotation))
	look_at(parent.offset)


func _on_body_entered(body: Node2D) -> void:
	if body == parent.get_child(1) :
		parent.misses += 1
