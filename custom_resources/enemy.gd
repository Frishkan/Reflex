class_name Enemy
extends Resource

enum Type {DUMMY, ATTACKER1, TANK1, BUFFER1, DEBUFFER1, ELITE1, BOSS1}

var type : Type
var position : Vector2
var index : int
