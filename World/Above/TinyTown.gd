extends "res://World/Areas/Area.gd"

func set_save_file():
	save_file = "res://Saves/%s.save" % get_name()
