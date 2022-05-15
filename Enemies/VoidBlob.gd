extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_SPEED = 35
export var FRICTION = 200
export var WANDER_BUFFER = 4

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var stats = $Stats
onready var full_sprite = $FullSprite
onready var half_sprite = $HalfSprite
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var blink_anim_player = $BlinkAnimationPlayer
onready var hurt_box = $HurtBox
onready var hit_box = $HitBox
onready var player_detection_zone = $PlayerDetectionZone
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController

func _ready():
	stats.set_max_health(3)
	stats.set_health(3)
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	match_dimension()
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
		
		WANDER:
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_BUFFER:
				update_wander()
		
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
		
		ATTACK:
			state = IDLE
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
			
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1,3))
	
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	hit_box.knockback_vector = velocity.normalized()
	full_sprite.flip_h = velocity.x > 0
	half_sprite.flip_h = velocity.x > 0

func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 130
	hurt_box.start_invincible(0.4)

func _on_Stats_no_health():
	queue_free()

func match_dimension():
	pass



func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")
