extends StaticBody2D


func save_scene():
	var save_game = File.new()
	save_game.open("res://Saves/BillsHouse.save", File.WRITE)
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
	if not save_game.file_exists("res://Saves/BillsHouse.save"):
		return
		
	save_game.open("res://Saves/BillsHouse.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())

		
		var node:Node = get_node(node_data["path"])
		if node_data.has("pos_x") and node_data.has("pos_y"):
			node.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		for i in node_data.keys():
			if i == "path" or i == "filename" or i == "pos_x" or i == "pos_y":
				continue
			if i == "active":
				if not node_data[i] and node is ChestAction:
					node.emit_signal("opened")
			node.set(i, node_data[i])
			
	save_game.close()
