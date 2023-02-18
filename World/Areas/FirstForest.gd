extends "res://World/Areas/Area.gd"

func set_save_file():
	save_file = "res://Saves/FirstForest.save"

func _process(delta):
	if Input.is_action_just_pressed("d_shift"):
		update_scene("World", "/root/Game/World/CutSceneTriggers/CutSceneTrigger", "active", true)
