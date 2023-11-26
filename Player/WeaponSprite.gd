extends Sprite

const SPRITE_SHEETS = {
	"SimpleSword": "res://Assets/Sprites/WeaponAnimations/SimpleSword.png",
	"SurvivalKnife": "res://Assets/Sprites/WeaponAnimations/SurvivalKnife.png"
}

func _ready():
	texture = ResourceLoader.load(SPRITE_SHEETS.SimpleSword)

func set_sprite(weapon):
	var reference = null
	match weapon:
		"Simple Sword":
			reference = SPRITE_SHEETS.SimpleSword
		"Survival Knife":
			reference = SPRITE_SHEETS.SurvivalKnife
	texture = ResourceLoader.load(reference)
