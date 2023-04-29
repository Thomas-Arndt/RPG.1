extends Node2D
class_name WorldScene

var save_file:String

func _ready():
	set_save_file()
	assert(save_file)

func set_save_file():
	save_file = "res://Saves/%s/%s.save" % [WorldStats.save_block, get_name()]

func save_scene():
	var save_game = File.new()
	save_game.open(save_file, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		save_game.store_line(to_json(node_data))
	save_game.close()

func load_scene():
	var save_game = File.new()
	if not save_game.file_exists(save_file):
		return
		
	save_game.open(save_file, File.READ)

	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		
		var node:Node = get_node(node_data["path"])
		if node != null:
			if node_data.has("pos_x") and node_data.has("pos_y"):
				node.position = Vector2(node_data["pos_x"], node_data["pos_y"])
			for i in node_data.keys():
				if i == "path" or i == "filename" or i == "pos_x" or i == "pos_y" or i == "spawn_count":
					continue
				if i == "active" and node is ChestAction:
					if not node_data[i]:
						node.emit_signal("opened")
						continue
				if i == "time_remaining":
					if node is SpawnController:
						for unit in node_data["spawn_count"]:
							node.spawn_new_unit()
						node.timer.start(node_data["time_remaining"])
						continue
					if node is ForageNode:
						node.forage(node_data["time_remaining"])
				if i == "triggered":
					if node_data[i] and node is RemoveNodeReceiver:
						node.remove_node(node.signal_code)
					if node_data[i] and node is AddNodeReceiver:
						var new_node = node.add_node_to(node.signal_code)
						if new_node is PortalNode:
							new_node.anim_player.stop()
							new_node.anim_player.play("holding")
				node.set(i, node_data[i])
			
	save_game.close()
	
func update_scene(scene_name:String, node_path:String, property_name:String, value):
	var write_stack : Array = []
	var save_game = File.new()
	var scene_save_location = "res://Saves/%s/%s.save" % [WorldStats.save_block, scene_name]
	if not save_game.file_exists(scene_save_location):
		return
		
	save_game.open(scene_save_location, File.READ)
	while save_game.get_position() < save_game.get_len():
		var sava_data = save_game.get_line()
		var node_data = parse_json(sava_data)

		if node_data["path"] == node_path:
			node_data[property_name] = value
		
		write_stack.push_back(node_data)
	save_game.close()
	save_game.open(scene_save_location, File.WRITE)
	while len(write_stack) > 0:
		save_game.store_line(to_json(write_stack.pop_back()))
	
	save_game.close()
		
func get_class():
	return "WorldScene"
