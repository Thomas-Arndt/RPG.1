extends Node2D
class_name CutScene

onready var controller : Node = $CutSceneController

func _ready():
	controller.run_cut_scene()

func load_scene():
	pass
