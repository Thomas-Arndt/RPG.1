extends Node2D
class_name CutScene

onready var controller : Node = $CutSceneController

func _ready():
	controller.package_choreography()
	controller.run_cut_scene()

func save_scene():
	pass

func load_scene():
	pass

func get_class():
	return "CutScene"
