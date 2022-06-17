extends StaticBody2D

onready var Footprint = $Footprint
onready var red_sprite = $RedSprite
onready var green_sprite = $GreenSprite

func _ready():
	Footprint.set_deferred("disabled", false)
	match_dimension()

func _process(delta):
	match_dimension()
	
func match_dimension():
	if WorldStats.DIMENSION == true:
		red_sprite.visible = true
		green_sprite.visible = false
	else:
		red_sprite.visible = false
		green_sprite.visible = true

func _on_AutomaticEntry_body_entered(body):
	Footprint.set_deferred("disabled", true)

func _on_AutomaticEntry_body_exited(body):
	Footprint.set_deferred("disabled", false)
