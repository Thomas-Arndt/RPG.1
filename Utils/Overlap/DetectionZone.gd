extends Area2D

var target = null;

func can_interact():
	return target != null

func _on_DetectionZone_area_entered(area):
	target = area


func _on_DetectionZone_area_exited(area):
	target = null
