extends Node

signal map_exited(room: Room)

signal item_recieved(item: Item)
signal card_recieved(card: Card)
signal gold_recieved(value : int)

signal card_played(card: Card)
signal card_recalculate()

signal turn_ended()
signal enemy_turn_ended()

signal first_enemy_turn_ended()
signal second_enemy_turn_ended()

signal qte_ended()
