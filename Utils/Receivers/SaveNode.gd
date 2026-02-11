extends Node

var save_dict = {}

func set_save_dict(dict_to_save):
	save_dict = dict_to_save

func save():
	return save_dict
