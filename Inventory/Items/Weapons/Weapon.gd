extends "res://Inventory/Items/Loot.gd"

func _on_Weapon_body_entered(body):
	on_body_entered(body)



func _on_Weapon_area_entered(area):
	if area is SwordHitBox and get_parent().active:
		on_area_entered(area)
