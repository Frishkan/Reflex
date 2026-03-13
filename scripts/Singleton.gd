extends Node

var hero_defence : int = 0
var hero_health : int
var hero_max_health : int

## 						0 - unplayed
## 						1 - played
## 						2 - voided
## 						3 - hand
var deck : Array[Array] = [[],[],[],[]]
var cards_count_in_hand_per_draw : int
var character : int

var run_gold : int
var run_exp : int

var run_rooms : int
var run_enemies : int
var run_elites : int
