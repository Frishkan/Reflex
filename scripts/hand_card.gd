class_name HandCard
extends Area2D

@onready var sprite_2d : Sprite2D = $Sprite2D

var card : Card : set = set_card

const ICONS := {
	Card.Name.KNIFE: [preload("res://textures/knife_card.png"), Vector2(1, 1)],
	Card.Name.SKILLFULL_BARRAGE: [preload("res://icon.svg"), Vector2(1, 1)],
}

func set_card(new_card: Card) :
	card = new_card
	self.position = card.position
	sprite_2d.texture = ICONS[card.name][0]
	self.scale = ICONS[card.name][1] * 0.35
