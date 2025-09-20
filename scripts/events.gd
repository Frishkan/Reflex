extends Node

signal map_exited(room: Room)

signal item_recieved(item: Item)
signal card_recieved(card: Card)
signal gold_recieved(value : int)

signal card_picked_up(card: Card)
signal card_played(card: Card)
signal card_voided(card: Card)
signal card_recalculate()
