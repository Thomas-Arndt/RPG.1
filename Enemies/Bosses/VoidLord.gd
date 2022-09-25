extends KinematicBody2D

export (bool) var is_red = true

onready var blink_anim_player = $BlinkAnimationPlayer
onready var hurt_box = $HurtBox
onready var stats = $Stats
onready var red_sprite_full = $RedSpriteFull
onready var red_sprite_half = $RedSpriteHalf
onready var green_sprite_full = $GrenSpriteFull
onready var green_sprite_half = $GreenSpriteHalf

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")

func match_dimension(state):
	red_sprite_full.visible = false
	red_sprite_half.visible = false
	green_sprite_full.visible = false
	green_sprite_half.visible = false
	hurt_box.monitorable = false
	hurt_box.monitoring = false
	
	if state == true and is_red:
		red_sprite_full.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
	elif state == false and is_red:
		red_sprite_half.visible = true
	elif state == true and not is_red:
		green_sprite_half.visible = true
	elif state == false and not is_red:
		green_sprite_full.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	hurt_box.start_invincible(0.6)


func _on_Stats_no_health():
	queue_free()
