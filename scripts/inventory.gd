extends Node2D

var items : Array
const INVENTORY_ITEM = preload("res://scenes/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.item_recieved.connect(_item_recieved)

func _item_recieved(item: Item) :
	items.append(item)
	item.position = Vector2(items.size() * 24, 0)
	var inventory_item = INVENTORY_ITEM.instantiate() as InventoryItem
	inventory_item.set_item(item)
	print(item.name)



func _on_deck_button_pressed() -> void:
	var new_item := Item.new()
	new_item.name = Item.Name.GUITAR
	Events.item_recieved.emit(new_item)
