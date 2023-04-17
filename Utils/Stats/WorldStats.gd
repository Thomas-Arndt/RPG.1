extends Node

signal dimension_shift(value)

var DIMENSION : int = Dimensions.Green
var last_loaded_scene : String = ""

var player_name : String = ""
var player_spawn_vector: Vector2 = Vector2(270, 165)
var player_spawn_direction: Vector2 = Vector2.DOWN

var save_block : String = "0"

func set_dimension(value : int):
	DIMENSION = value
	emit_signal("dimension_shift", DIMENSION)

func get_dimension() -> int:
	return DIMENSION
	
func set_last_loaded_scene(scene):
	last_loaded_scene = scene

func get_last_loaded_scene() -> String:
	return last_loaded_scene
	
func save_stats():
	var save_game = File.new()
	save_game.open("res://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.WRITE)
	var node_data = {
		"DIMENSION" : DIMENSION,
		"player_spawn_vector_x" : player_spawn_vector.x,
		"player_spawn_vector_y" : player_spawn_vector.y,
		"player_spawn_direction_x" : player_spawn_direction.x,
		"player_spawn_direction_y" : player_spawn_direction.y,
		"player_name": player_name,
		"last_loaded_scene" : last_loaded_scene,
	}
	save_game.store_line(to_json(node_data))
	save_game.close()

func load_stats():
	var save_game = File.new()
	if not save_game.file_exists("res://Saves/%s/%s.save" % [WorldStats.save_block, get_name()]):
		return
	save_game.open("res://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.READ)
	var node_data = parse_json(save_game.get_line())
	for i in node_data.keys():
		match i:
			"player_spawn_vector_x":
				player_spawn_vector.x = node_data[i]
				continue
			"player_spawn_vector_y":
				player_spawn_vector.y = node_data[i]
				continue
			"player_spawn_direction_x":
				player_spawn_direction.x = node_data[i]
				continue
			"player_spawn_direction_y":
				player_spawn_direction.y = node_data[i]
				continue
		self.set(i, node_data[i])
	save_game.close()
	
enum Dimensions {
	Red,
	Green,
	Between,
}
