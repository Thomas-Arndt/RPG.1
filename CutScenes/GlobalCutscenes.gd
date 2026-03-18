extends Node

var cutscenes = []

func _ready():
	cutscenes = get_children()
	SignalBus.connect("run_global_cutscene", self, "run_cutscene")

func run_cutscene(cutscene_name):
	for cutscene in cutscenes:
		if cutscene.name == cutscene_name:
			cutscene.start_cutscene(get_tree().get_nodes_in_group("Player")[0])
			return
			
