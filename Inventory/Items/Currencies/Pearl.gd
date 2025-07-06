extends "res://Inventory/Items/Loot.gd"

var damage = 0
var knockback_vector = Vector2.ZERO

func _on_Pearl_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		pick_up_pearl()

func _on_Pearl_area_entered(area):
	if area is SwordHitBox and get_parent().active:
		pick_up_pearl()

func pick_up_pearl():
	Inventory.change_muon_pearls(1)
	get_parent().queue_free()
