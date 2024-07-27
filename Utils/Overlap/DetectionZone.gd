extends Area2D

var target = null;

func can_interact():
	return target != null

func target_is_player():
	var result = target.get_parent() == get_tree().get_nodes_in_group("Player")[0]
	print(target.get_parent())
	return result

func _on_DetectionZone_area_entered(area):
	target = area


func _on_DetectionZone_area_exited(_area):
	target = null
