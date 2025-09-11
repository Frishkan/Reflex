class_name HandCard
extends Area2D

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var name_label : Label = $Name
@onready var short_desc : Label = $ShortDesc


var card : Card : set = set_card

const ICONS := {
	Card.Name.KNIFE: [preload("res://textures/knife_card.png"), Vector2(1, 1), "Knife", "2 * hits/10"],
	Card.Name.SKILLFULL_BARRAGE: [preload("res://icon.svg"), Vector2(1, 1), "Skillfull barrage", "3 * hits/10 - 2 * (10 - hits/10)"],
}

func set_card(new_card: Card) :
	card = new_card
	self.position = card.position
	self.rotation = card.rotation
	sprite_2d.texture = ICONS[card.name][0]
	name_label.text = ICONS[card.name][2]
	short_desc.text = ICONS[card.name][3]
	self.scale = ICONS[card.name][1]


func _on_mouse_entered() -> void:
	self.scale = self.scale * 1.5


func _on_mouse_exited() -> void:
	self.scale = self.scale / 1.5



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	while event.is_action_pressed("left_mouse") : ## fix this!!
		self.position = get_global_mouse_position()
