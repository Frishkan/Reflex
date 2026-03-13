extends Node2D

var speed = 0
var type : int
var chord : int
var hit := false

@onready var chord_label : Label = $Label
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	type = randi_range(0, 2)
	if type == 0 :
		chord_label.visible = false
		sprite.texture = preload("res://icon.svg")
	elif type == 2 :
		sprite.rotation_degrees = 180
	match get_parent().get_parent().random_chord :
		0 :
			chord_label.text = "Am"
		1 :
			chord_label.text = "S"
		2 :
			chord_label.text = "Dm"
		3 :
			chord_label.text = "F"
	chord = get_parent().get_parent().random_chord
	get_parent().get_parent().counter += 1

func _physics_process(delta: float) -> void:
	translate(Vector2(speed * delta * -1, 0))
	if position.x <= -1000 :
		queue_free()
