class_name Item
extends Resource

enum Name {GUITAR, HEAL, NODISCARD, MOREREWARD, MAXHP}
enum Rarity {COMMON, UNCOMMON, RARE, CURSED}

var name : Name
var rarity : Rarity
var position : Vector2
