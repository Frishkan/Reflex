extends Node

signal map_exited(room: Room)

signal character_choosen()

signal item_recieved(item: Item)
signal card_recieved(card: Card)
signal gold_recieved(value: int)

signal card_played(card: Card)
signal card_recalculate()
signal choosed_enemy_index(index : int)

signal turn_ended()
signal enemy_turn_ended()
signal enemy_turned()

signal qte_ended()

signal circle_qte_hit()
