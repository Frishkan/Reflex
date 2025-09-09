class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, ELITE, BOSS}

var type: Type
var row: int
var column: int
var position: Vector2
var next_rooms:Array[Room]
var selected := false
