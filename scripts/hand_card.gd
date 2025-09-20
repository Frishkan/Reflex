class_name HandCard
extends Control

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var name_label : Label = $Name
@onready var short_desc : Label = $ShortDesc


var card : Card : set = set_card
var index : int
var hand_size := 800
var hand_card_name : Card.Name


const ICONS := {
	Card.Name.KNIFE: [preload("res://textures/knife_card.png"), Vector2(1, 1), "Knife", "2 * hits/10"],
	Card.Name.SKILLFULL_BARRAGE: [preload("res://icon.svg"), Vector2(1, 1), "Skillfull barrage", "3 * hits/10 - 2 * (10 - hits/10)"],
}

func _ready() -> void:
	Events.card_recalculate.connect(_recalculate_position)

func set_card(new_card: Card) :
	card = new_card
	self.position = card.position
	sprite_2d.texture = ICONS[card.name][0]
	name_label.text = ICONS[card.name][2]
	short_desc.text = ICONS[card.name][3]
	self.scale = ICONS[card.name][1]
	index = card.index
	hand_card_name = card.name


func _on_mouse_entered() -> void:
	self.scale = self.scale * 1.5
	self.position += - Vector2(40, 80)
	self.z_index += 1



func _on_mouse_exited() -> void:
	self.scale = self.scale / 1.5
	self.position += + Vector2(40, 80)
	self.z_index += - 1


func _on_input_event(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") : 
		Events.card_played.emit(self)
		queue_free()

func _recalculate_position() : ## hand ~ 800 px , card size ~ 120 px (es esmu tik dumjs aaaaaaaaaaaaaaa)
	## var new_card_position := (index * 800 / (get_parent().get_child_count() + 1)) not next to each other (at start)
	## var new_card_position := 800 / 2 + index * 50 * (-1 ** index) not responsive
	## var new_card_position = hand_size / 2 + (index * clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120)) - 60 * (get_parent().get_child_count() + 1) runs to the left when card speces changes:(
	var new_card_position = (index * clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120)) - (clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120) / 800) * (get_parent().get_child_count() + 1)
	
	self.position = Vector2(new_card_position, 0)
