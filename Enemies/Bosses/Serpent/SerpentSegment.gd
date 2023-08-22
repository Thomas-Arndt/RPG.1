extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 200
export var FRICTION = 500

onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf
onready var anim_player : Node = $AnimationPlayer
onready var blink_anim_player : Node = $BlinkAnimationPlayer
onready var stats : Node = $Stats
onready var hurt_box : Node = $HurtBox

var red_blob = preload("res://Enemies/RedVoidBlob.tscn")

var previous_segment : Node = null
var next_segment : Node = null

var velocity = Vector2.ZERO
var knockback : Vector2 = Vector2.ZERO

var blob_clones : int = 1
var active : bool = true

func _ready():
	yield(get_tree().create_timer(rand_range(0, 0.4)), "timeout")
	anim_player.play("move")

func follow_the_leader(leader_position, delta):
	var distance_to_leader = global_position.distance_to(leader_position)
	if previous_segment.is_head() and distance_to_leader <= 26:
		velocity = Vector2.ZERO
	elif not previous_segment.is_head() and distance_to_leader <= 22:
		velocity = Vector2.ZERO
	else:
		var follow_vector = global_position.direction_to(leader_position)
		follow_vector = follow_vector.normalized()
		velocity = velocity.move_toward(follow_vector * MAX_SPEED, ACCELERATION * delta)
		flip_sprites()
	velocity = move_and_slide(velocity)
	if next_segment != null:
		next_segment.follow_the_leader(global_position, delta)

func is_head():
	return false

func flip_sprites():
	red_sprite_full.flip_h = velocity.x > 0
	red_sprite_half.flip_h = velocity.x > 0
	green_sprite_full.flip_h = velocity.x > 0
	green_sprite_half.flip_h = velocity.x > 0


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	area.set_knockback_vector(self) 
	knockback = area.knockback_vector * 130
	move_and_slide(knockback)
	hurt_box.start_invincible(0.6)


func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")


func _on_Stats_no_health():
	segment_to_blob()

func segment_to_blob():
	if active:
		active = not active
		if previous_segment != null:
			previous_segment.next_segment = null
			
		if next_segment != null:
			next_segment.previous_segment = null
			next_segment.segment_to_blob()
			
		queue_free()
		for blob in range(blob_clones):
			new_blob()


func new_blob():
	var new_blob = red_blob.instance()
	new_blob.position = position
	get_parent().add_child(new_blob)
	new_blob.hurt_box.start_invincible(0.4)
	new_blob.knockback = knockback
	new_blob.stats.set_max_health(3)
	new_blob.stats.set_health(3)	
	
