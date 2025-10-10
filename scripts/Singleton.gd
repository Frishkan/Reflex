extends Node

var hero_health : int

## 						0 - unplayed
## 						1 - played
## 						2 - voided
## 						3 - hand
var deck : Array[Array] = [[],[],[],[]]
var cards_count_in_hand_per_draw : int
var character : int

var run_gold : int

var run_exp : int
