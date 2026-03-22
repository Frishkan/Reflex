extends Node

var hero_defense : int = 0
var hero_health : int
var hero_max_health : int

var deck : Array[Array] = [[],[],[],[]] ## [unplayed, played, voided, hand]
var items : Array[String] = []
var cards_count_in_hand_per_draw : int
var character : int

var run_gold : int = 0
var run_exp : int

var run_rooms : int
var run_enemies : int
var run_elites : int
