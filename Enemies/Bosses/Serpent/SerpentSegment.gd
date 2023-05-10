extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 200
export var FRICTION = 800

onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf
onready var anim_player : Node = $AnimationPlayer

var previous_segment : Node = null
var next_segment : Node = null

var velocity = Vector2.ZERO

func _ready():
	yield(get_tree().create_timer(rand_range(0, 0.4)), "timeout")
	anim_player.play("move")

func follow_the_leader(leader_position, delta):
	var follow_vector = global_position.direction_to(leader_position)
	follow_vector = follow_vector.normalized()
	if (previous_segment.is_head() and global_position.distance_to(leader_position) <= 26) or (not previous_segment.is_head() and global_position.distance_to(leader_position) <= 18):
		velocity = Vector2.ZERO
	else:
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
