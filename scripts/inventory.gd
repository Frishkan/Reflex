extends Node2D

const INVENTORY_ITEM = preload("res://scenes/inventory_item.tscn")
@onready var items : Node2D = %Items

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.item_recieved.connect(_item_recieved)

func _item_recieved(item: Item) :
	item.position = Vector2(items.get_child_count() * 50 + 25, 85)
	_spawn_item(item)

func _spawn_item(item : Item) :
	var inventory_item = INVENTORY_ITEM.instantiate() as InventoryItem
	items.add_child(inventory_item)
	inventory_item.set_item(item)
	inventory_item.item = item
	

func _on_deck_button_pressed() -> void:
	var new_item := Item.new()
	new_item.name = Item.Name.GUITAR
	Events.item_recieved.emit(new_item)
