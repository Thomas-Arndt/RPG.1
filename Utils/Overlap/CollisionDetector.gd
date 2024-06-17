extends Area2D

signal collision_detected(object)



func _on_CollisionDetector_area_entered(area):
	emit_signal("collision_detected", area)


func _on_CollisionDetector_body_entered(body):
	emit_signal("collision_detected", body)
