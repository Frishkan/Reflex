extends Area2D

@onready var parent := get_parent().get_parent()

var time_elapsed : float

func _process(delta: float) -> void:
	time_elapsed += delta
	self.position = Vector2(sin(time_elapsed * parent.local_card_stats[0]) * parent.radius, cos(time_elapsed * parent.local_card_stats[0]) * parent.radius) + parent.offset


func _on_body_entered(body: Node2D) -> void:
	if body == parent.get_child(1) :
		parent.misses += 1
