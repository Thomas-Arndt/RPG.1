extends Resource
class_name Item

export (String) var name = ""
export (Texture) var texture
export (String) var type = ""
export (int) var heal = 1

var quantity: int = 1

func action():
	match type:
		"potion":
			PlayerStats.change_health(heal)
