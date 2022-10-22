extends Area2D

export var spawn_with_cut_scene = false

onready var anim_player = $AnimationPlayer
onready var green_sprite = $GreenSprite
onready var red_sprite = $RedSprite

func _ready():
	WorldStats.connect("dimension_shift", self, "match_dimension")
	match_dimension(WorldStats.DIMENSION)
	if spawn_with_cut_scene:
		self.visible = false
	else:
		open_and_hold()

func match_dimension(dimension):
	if dimension == false:
		green_sprite.visible = false
		red_sprite.visible = true
	else:
		green_sprite.visible = true
		red_sprite.visible = false

func open_and_hold():
	anim_player.queue("open")
	anim_player.queue("holding")

func close():
	anim_player.stop()
	anim_player.play("close")



func _on_Portal_body_entered(body):
	WorldStats.shift_dimension()
