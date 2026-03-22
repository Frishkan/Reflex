class_name HandCard
extends Control

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var name_label : Label = $Name
@onready var short_desc : Label = $ShortDesc
@onready var qte_icon : Sprite2D = $QTEIcon
@onready var hud : Node2D = $/root/game/hud
@onready var qtes : Node2D = $/root/game/FightScene/QTEs
@onready var fight_scene : Node2D = $/root/game/FightScene

var card : Card : set = set_card 
var index : int
var hand_size := 800
var hand_card_name : Card.Name
var is_usable_in_hand := true
var upgraded := 0
var needs_choosing := 0

func _ready() -> void:
	Events.card_recalculate.connect(_recalculate_position)

func set_card(new_card: Card) : ##!!
	card = new_card
	var icons = CardsLibrary.ICONS[card.name]
	var stats = CardsLibrary.STATS[card.name]
	var hand_last = Singleton.deck[3][Singleton.deck[3].size() - 1]
	self.position = card.position
	sprite_2d.texture = icons[0]
	name_label.text = icons[2]
	qte_icon.texture = icons[4]
	short_desc.text = str(stats[hand_last[1]][0])
	if fight_scene.effects[0] > 0 : ## weak check
		short_desc.text = str(int(stats[hand_last[1]][0] * 0.75))
	if fight_scene.effects[4] > 0 : ## strenght check
		short_desc.text = str(int(stats[hand_last[1]][0] * 1.25))
	if stats[hand_last[1]][1] != 0 :
		short_desc.text += " * " + str(stats[hand_last[1]][1])
		if stats[hand_last[1]][2] != 0 :
			short_desc.text += " - " + str(stats[hand_last[1]][2]) + " * " + str(stats[hand_last[1]][1])
	if stats[2] != "" :
		short_desc.text += " " + str(stats[2])
	upgraded = hand_last[1]
	needs_choosing = stats[3]
	self.scale = icons[1]
	index = new_card.index
	hand_card_name = new_card.name

func _on_mouse_entered() -> void:
	self.scale = self.scale * 1.5
	self.position -= Vector2(40, 80)
	self.z_index += 1

func _on_mouse_exited() -> void:
	self.scale = self.scale / 1.5
	self.position += Vector2(40, 80)
	self.z_index -= 1

func _on_input_event(event: InputEvent) -> void: ##!!
	if event.is_action_pressed("left_mouse") && hud.upgrading :
		Singleton.deck[0][index][1] = 1
	elif event.is_action_pressed("left_mouse") && !qtes.qte_active && is_usable_in_hand && !fight_scene.card_choosing:
		if needs_choosing :
			fight_scene.card_choosing = 1
			position.y -= 40
			z_index += 2
			await Events.choosed_enemy_index
		Events.card_played.emit(self)
		queue_free()

func _recalculate_position() : ## hand ~ 800 px , card size ~ 120 px (es esmu tik dumjs aaaaaaaaaaaaaaa)
	## var new_card_position := (index * 800 / (get_parent().get_child_count() + 1)) not next to each other (at start)
	## var new_card_position := 800 / 2 + index * 50 * (-1 ** index) not responsive
	## var new_card_position = hand_size / 2 + (index * clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120)) - 60 * (get_parent().get_child_count() + 1) runs to the left when card speces changes:(
	var new_card_position = (index * clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120)) - (clamp(hand_size / (get_parent().get_child_count() + 1), 0, 120) / 800) * (get_parent().get_child_count() + 1)
	
	self.position = Vector2(new_card_position, 0)
