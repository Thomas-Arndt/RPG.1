extends Node

export var scene_name : String
export var node_path : String
export var property_name : String
export var value : Array

func apply():
	get_tree().get_nodes_in_group("World")[0].update_scene(scene_name, node_path, property_name, value[0])
