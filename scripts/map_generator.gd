class_name MapGenerator
extends Node2D

const x_dist := 30
const y_dist := 25
@export var placement_randomness := 5
## ^ how much rooms leave the grid 
const floors := 15 ## rows
const floor_width := 7
@export var paths := 6 ## max paths, not starting points
@export var monster_weight := 8.0
@export var shop_weight := 2.5
@export var campfire_weight := 4.0
@export var elite_weight := 2.0

var rand_room_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.ELITE: 0.0
}

var rand_room_total_weight := 0
var map_data : Array[Array]

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in floors - 1:
			current_j = _setup_connection(i, current_j)
	
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	
	
	var i := 0
	for floor in map_data:
		print("floor %s" % i)
		var used_rooms_floor = floor.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)
		var used_rooms_columns = []
		for room in used_rooms_floor :
			used_rooms_columns.append(room.column)
			used_rooms_columns.append(room.type)
		print(used_rooms_columns)
		i += 1
	
	return map_data

func _ready() -> void:
	generate_map()

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in floors:
		var adjacent_room : Array[Room] = []
		
		for j in floor_width: 
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * placement_randomness
			current_room.position = Vector2(j * x_dist, i * -y_dist) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			## const y for the boss room
			if i == floors - 1 :
				current_room.position.y = (i + 1) * -y_dist
			
			adjacent_room.append(current_room)
		
		result.append(adjacent_room)
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates : Array[int]
	var unique_points : int = 0
	
	while unique_points < 2 :
		unique_points = 0
		y_coordinates = []
		
		for i in paths :
			var starting_points := randi_range(0, floor_width - 1)
			if not y_coordinates.has(starting_points) :
				unique_points += 1
			
			y_coordinates.append(starting_points)
	return y_coordinates

func _setup_connection(i : int, j : int) -> int :
	var next_room : Room
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, floor_width - 1)
		next_room = map_data[i + 1][random_j]
		
	current_room.next_rooms.append(next_room)
	
	return next_room.column

							   ## current room     next room
func _would_cross_existing_path(i : int, j : int, room: Room) -> bool :
	var left_neighbour : Room
	var right_neighbour : Room
	
	## if j == 0 then no left neighbour; if j == floor_width - 1, no right
	if j > 0 :
		left_neighbour = map_data[i][j - 1]
	if j < floor_width - 1 :
		right_neighbour = map_data[i][j + 1]
	
	## cant go right if right_neighbour goes left etc.
	if right_neighbour and room.column > j :
		for next_room : Room in right_neighbour.next_rooms :
			if next_room.column < room.column :
				return true
	
	## same for left
	if left_neighbour and room.column < j :
		for next_room : Room in left_neighbour.next_rooms :
			if next_room.column > room.column :
				return true
	
	return false

func _setup_boss_room() -> void :
	var middle := floori(floor_width * 0.5)
	var boss_room := map_data[floors - 1][middle] as Room
	for j in floor_width :
		var current_room := map_data[floors - 2][j] as Room
		if current_room.next_rooms :
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
			
	boss_room.type = Room.Type.BOSS

func _setup_random_room_weights() -> void :
	rand_room_weights[Room.Type.MONSTER] = monster_weight
	rand_room_weights[Room.Type.CAMPFIRE] = monster_weight + campfire_weight
	rand_room_weights[Room.Type.SHOP] = monster_weight + campfire_weight + shop_weight
	rand_room_weights[Room.Type.ELITE] = monster_weight + campfire_weight + shop_weight + elite_weight
	
	rand_room_total_weight = rand_room_weights[Room.Type.ELITE]

func _setup_room_types() -> void :
	## first floor is always battle
	for room : Room in map_data[0] :
		if room.next_rooms.size() > 0 :
			room.type = Room.Type.MONSTER
	
	## middle room is always chest
	for room : Room in map_data[floori(floors * 0.5)] :
		if room.next_rooms.size() > 0 :
			room.type = Room.Type.TREASURE
	
	## room before boss is always campfire
	for room : Room in map_data[floors - 2] :
		if room.next_rooms.size() > 0 :
			room.type = Room.Type.CAMPFIRE
	
	## rest of the floors (rand)
	for current_floor in map_data :
		for room : Room in current_floor :
			for next_room : Room in room.next_rooms :
				if next_room.type == Room.Type.NOT_ASSIGNED :
					_set_room_randomly(next_room)

func _set_room_randomly(room_to_set: Room) -> void :
	var campfire_below_4 := true
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_on_13 := true
	
	var type_candidate: Room.Type
	
	while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_on_13 :
		type_candidate = _get_random_room_type_by_weight()
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)
		
		campfire_below_4 = is_campfire and room_to_set.row <= 3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_on_13 = is_campfire and room_to_set.row == 12
	
	room_to_set.type = type_candidate

func _room_has_parent_of_type(room : Room, type : Room.Type) -> bool :
	var parents : Array[Room]  = []
	## left parent
	if room.column > 0 and room.row > 0 :
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room) :
			parents.append(parent_candidate)
	
	## middle parent
	if room.row > 0 :
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room) :
			parents.append(parent_candidate)
	
	## right parent
	if room.column < floor_width - 1 and room.row > 0 :
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room) :
			parents.append(parent_candidate)
	
	for parent: Room in parents :
		if parent.type == type :
			return true
	return false

func _get_random_room_type_by_weight() -> Room.Type :
	var roll := randf_range(0.0, rand_room_total_weight)
	
	for type : Room.Type in rand_room_weights :
		if rand_room_weights[type] > roll :
			return type
	
	return Room.Type.MONSTER
