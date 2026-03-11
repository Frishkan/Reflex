extends Node2D

var speed = 0
var type : int
var chord : int
var hit := false

func _ready() -> void:
	type = randi_range(0, 2)
	if type == 0 :
		$Label.visible = false
		$Sprite2D.texture = preload("res://icon.svg")
	elif type == 2 :
		$Sprite2D.rotation_degrees = 180
	match get_parent().get_parent().random_chord :
		0 :
			$Label.text = "Am"
		1 :
			$Label.text = "S"
		2 :
			$Label.text = "Dm"
		3 :
			$Label.text = "F"
	chord = get_parent().get_parent().random_chord
	get_parent().get_parent().counter += 1

func _physics_process(delta: float) -> void:
	translate(Vector2(speed * delta * -1, 0))
	if position.x <= -1000 :
		queue_free()
