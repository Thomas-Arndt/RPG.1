extends YSort

export (float) var respawn_time = 60
export (float) var quick_respawn = 5
export (int) var max_active_nodes = 1

var forage_layer_components : Array = []
var active_node_count : int = 0

onready var forage_nodes = $ForageNodes
onready var timer = $Timer

func _ready():
	var has_save = File.new().file_exists(get_tree().get_nodes_in_group("World")[0].save_file)
	forage_layer_components = forage_nodes.get_children()
	for node in forage_layer_components:
		node.connect("gathered", self, "_on_Gathered")
		if !has_save:
			node.disable_node()
	timer.connect("timeout", self, "_on_Timer_timeout")
	if !has_save:
		activate_node()
	activate_node()
		

func _on_Gathered():
	active_node_count -= 1
	if timer.time_left <= 0:
		activate_node()
		
func activate_node():
	if forage_layer_components.size() > 0:
		if active_node_count < max_active_nodes:
			var random_index = randi() % forage_layer_components.size()
			var forage_node = forage_layer_components[random_index]
			if forage_node.available:
				forage_node.grow()
				active_node_count += 1
				timer.start(respawn_time)
			else:
				timer.start(quick_respawn)
		else:
			timer.start(respawn_time)

func _on_Timer_timeout():
	activate_node()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left,
		"active_node_count" : active_node_count,
		"class" : "ForageLayerNode"
	}
	return save_dict
