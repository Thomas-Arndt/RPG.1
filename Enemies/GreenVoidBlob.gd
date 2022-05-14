extends "res://Enemies/VoidBlob.gd"


func match_dimension():
	if WorldStats.DIMENSION == true:
		full_sprite.visible = false
		hurt_box.monitorable = false
		hurt_box.monitoring = false
	else:
		full_sprite.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
