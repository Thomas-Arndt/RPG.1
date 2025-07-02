extends "res://Inventory/Items/Loot.gd"

func _on_Pearl_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		PlayerStats.set_muon_pearls(PlayerStats.muonPearls + 1)
		PlayerStats.save_stats()
		get_parent().queue_free()
