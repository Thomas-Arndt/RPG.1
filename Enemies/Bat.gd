extends KinematicBody2D

signal died(node)


export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_BUFFER = 4
export (bool) var is_red = false
export (bool) var state_machine_paused = false

enum {
	IDLE,
	WANDER,
	CHASE,
}

var Name= "Bat"

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE
var DeathEffect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var red_full_sprite = $RedFullSprite
onready var red_half_sprite = $RedHalfSprite
onready var green_full_sprite = $GreenFullSprite
onready var green_half_sprite = $GreenHalfSprite
onready var hurt_box = $HurtBox
onready var soft_collisions = $SoftCollision
onready var wander_controller = $WanderController
onready var blink_animation_player = $BlinkAnimationPlayer

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	if !state_machine_paused:
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
				var player = player_detection_zone.detected_body
				if player != null:
					accelerate_towards_point(player.global_position, delta)
				else:
					state = IDLE
			
		if soft_collisions.is_colliding():
			velocity += soft_collisions.get_push_vector() * delta * 400
		velocity = move_and_slide(velocity)
			
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1,3))

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
	flip_h(velocity.x < 0)

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_Stats_no_health():
	emit_signal("died", self)
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)


func _on_HurtBox_invincible_end():
	blink_animation_player.play("stop")


func _on_HurtBox_invincible_start():
	blink_animation_player.play("start")


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 130
	hurt_box.create_hit_effect()
	hurt_box.start_invincible(0.4)

func match_dimension(state):
	red_full_sprite.visible = false
	red_half_sprite.visible = false
	green_full_sprite.visible = false
	green_half_sprite.visible = false
	hurt_box.is_red = is_red	
	if is_red and state == WorldStats.Dimensions.Red:
		red_full_sprite.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif is_red and not state == WorldStats.Dimensions.Red:
		red_half_sprite.visible = true
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif not is_red and state == WorldStats.Dimensions.Green:
		green_full_sprite.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
	elif not is_red and not state == WorldStats.Dimensions.Green:
		green_half_sprite.visible = true
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
		
func flip_h(val):
	red_full_sprite.flip_h = val
	red_half_sprite.flip_h = val
	green_full_sprite.flip_h = val
	green_half_sprite.flip_h = val
