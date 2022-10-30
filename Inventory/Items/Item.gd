extends Resource
class_name Item

export (String) var name = ""
export (Texture) var texture
export (String) var type = ""
export (int) var heal = 0
export (int) var damage = 0

var quantity: int = 1

func action(player = null):
	match type:
		"potion":
			PlayerStats.change_health(heal)
		"weapon":
			player.sword_hit_box.damage = damage
			player.state = player.ATTACK
