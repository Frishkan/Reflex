class_name InventoryItem
extends Sprite2D


var item : Item : set = set_item

const ICONS := {
	Item.Name.GUITAR: [preload("res://icon.svg"), Vector2(1, 1)],
	Item.Name.HEAL: [preload("res://icon.svg"), Vector2(1, 1)],
	Item.Name.NODISCARD: [preload("res://icon.svg"), Vector2(1, 1)],
	Item.Name.MOREREWARD: [preload("res://icon.svg"), Vector2(1, 1)],
	Item.Name.MAXHP: [preload("res://icon.svg"), Vector2(1, 1)]
}

func set_item(new_item: Item) :
	item = new_item
	self.position = item.position
	self.texture = ICONS[item.name][0]
	self.scale = ICONS[item.name][1] * 0.35
