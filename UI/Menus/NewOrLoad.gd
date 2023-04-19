extends Control

onready var selector : Node = $CenterContainer/NoLSelector

var active : bool = true

func _ready():
	for i in range(3):
		var block = selector.get_child(i)
		var data = get_save_block_data(i)
		block.text = data["block_name"]
		block.action = data["action"]
		block.code = i

func get_save_block_data(save_block) -> Object:
	var block_data = {"block_name": "(" + str(save_block+1) + ") ", "action": null}
	var save_game = File.new()
	if not save_game.file_exists("res://Saves/%s/%s.save" % [save_block, "WorldStats"]):
		block_data["block_name"] += "New Game"
		block_data["action"] = "new_menu"
		return block_data
	save_game.open("res://Saves/%s/%s.save" % [save_block, "WorldStats"], File.READ)
	var node_data = parse_json(save_game.get_line())
	for i in node_data.keys():
		if i == "player_name":
			block_data["block_name"] += node_data[i]
	block_data["action"] = "load"
	return block_data
