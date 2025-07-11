extends KinematicBody2D

class_name VoidBlob

signal died(enemy)

export var is_red : bool = false
export var ACCELERATION = 200
export var MAX_SPEED = 35
export var FRICTION = 200
export var WANDER_BUFFER = 4

export(int) var _experience_reward = 25
export (bool) var state_machine_paused = false

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var Name = "Void Blob"

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var default_damage = 1
var explosion_damage = 3
var state = IDLE
var DeathEffect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
var attacking = false

onready var stats = $Stats
onready var green_full_sprite = $GreenFullSprite
onready var green_half_sprite = $GreenHalfSprite
onready var red_full_sprite = $RedFullSprite
onready var red_half_sprite = $RedHalfSprite
onready var green_full_attack_sprite = $GreenFullAttackSprite
onready var green_half_attack_sprite = $GreenHalfAttackSprite
onready var red_full_attack_sprite = $RedFullAttackSprite
onready var red_half_attack_sprite = $RedHalfAttackSprite
onready var anim_player = $AnimationPlayer
onready var blink_anim_player = $BlinkAnimationPlayer
onready var attack_anim_player = $AttackAnimationPlayer
onready var hurt_box = $HurtBox
onready var hit_box = $HitBox
onready var player_detection_zone = $PlayerDetectionZone
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var attack_raduis = $AttackRadius

func _ready():
	set_visible(false)
	state_machine_paused = true
	WorldStats.connect("dimension_shift", self, "match_dimension")
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	death_effect.death = false
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)
	death_effect.connect("animation_finished", self, "_on_enter_animation_finished")
	get_parent().add_child(death_effect)
	
func _on_enter_animation_finished():
	match_dimension(WorldStats.DIMENSION)
	state_machine_paused = false
	stats.set_max_health(3)
	stats.set_health(3)
	state = pick_random_state([IDLE, WANDER])
	attack_raduis.duration = 0.25
	anim_player.play("SETUP")
	anim_player.play("idle")
	
func _physics_process(delta):
	if !state_machine_paused:
		knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
		apply_knockback()
		
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
			
			ATTACK:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				if velocity == Vector2.ZERO and !attacking:
					hit_box.damage = explosion_damage
					attack_anim_player.play("explosion")
					attacking = true
			
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
	flip_sprites(velocity)

func apply_knockback():
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	if state != ATTACK:
		knockback = area.knockback_vector * 130
	hurt_box.create_hit_effect()
	hurt_box.start_invincible(0.4)

func _on_Stats_no_health():
	emit_signal("died", self)
	PlayerStats.change_experience(_experience_reward)
	SignalBus.emit_signal("drop_item", global_position, [[2, 0.8], [1, 0.1], [3, 0.1]], null, null, Inventory.ItemResources.MUON_PEARL)
	queue_free()
	death_animation()
	
func leave_dimension():
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)
	get_parent().add_child(death_effect)
	
func death_animation():
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position

func _on_HurtBox_invincible_start():
	set_or_toggle_hurtbox_state(false)
	blink_anim_player.play("start")

func _on_HurtBox_invincible_end():
	set_or_toggle_hurtbox_state(true)
	blink_anim_player.play("stop")

func _on_AttackRadius_explosion_attack():
	apply_attack_sprite(WorldStats.DIMENSION)
	state = ATTACK

func on_attack_animation_complete():
	hit_box.damage = default_damage
	hide_attack_sprites()
	match_dimension(WorldStats.DIMENSION)
	attacking = false
	state = IDLE

func change_home_dimension():
	is_red = !is_red
	hurt_box.is_red = is_red	
	apply_attack_sprite(WorldStats.DIMENSION)

func match_dimension(state):
	hide_sprites()
	if is_red and state == WorldStats.Dimensions.Red:
		red_full_sprite.visible = true
		set_or_toggle_hurtbox_state(true)
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif is_red and not state == WorldStats.Dimensions.Red:
		red_half_sprite.visible = true
		set_or_toggle_hurtbox_state(false)
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif not is_red and state == WorldStats.Dimensions.Green:
		green_full_sprite.visible = true
		set_or_toggle_hurtbox_state(true)
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
	elif not is_red and not state == WorldStats.Dimensions.Green:
		green_half_sprite.visible = true
		set_or_toggle_hurtbox_state(false)
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

func apply_attack_sprite(state):
	hide_sprites()
	hide_attack_sprites()
	if is_red and state == WorldStats.Dimensions.Red:
		red_full_attack_sprite.visible = true
	elif is_red and not state == WorldStats.Dimensions.Red:
		red_half_attack_sprite.visible = true
	elif not is_red and state == WorldStats.Dimensions.Green:
		green_full_attack_sprite.visible = true
	elif not is_red and not state == WorldStats.Dimensions.Green:
		green_half_attack_sprite.visible = true
	
func hide_sprites():
	red_full_sprite.visible = false
	red_half_sprite.visible = false
	green_full_sprite.visible = false
	green_half_sprite.visible = false

func hide_attack_sprites():
	red_full_attack_sprite.visible = false
	red_half_attack_sprite.visible = false
	green_full_attack_sprite.visible = false
	green_half_attack_sprite.visible = false

func set_visible(visible):
	red_full_sprite.set_deferred("visible", visible)
	red_half_sprite.set_deferred("visible", visible)
	green_full_sprite.set_deferred("visible", visible)
	green_half_sprite.set_deferred("visible", visible)
	red_full_attack_sprite.set_deferred("visible", visible)
	red_half_attack_sprite.set_deferred("visible", visible)
	green_full_attack_sprite.set_deferred("visible", visible)
	green_half_attack_sprite.set_deferred("visible", visible)
	
func flip_sprites(velocity):
	green_full_sprite.flip_h = velocity.x > 0
	green_half_sprite.flip_h = velocity.x > 0
	red_full_sprite.flip_h = velocity.x > 0
	red_half_sprite.flip_h = velocity.x > 0
	green_full_attack_sprite.flip_h = velocity.x > 0
	green_half_attack_sprite.flip_h = velocity.x > 0
	red_full_attack_sprite.flip_h = velocity.x > 0
	red_half_attack_sprite.flip_h = velocity.x > 0
	
func set_or_toggle_hurtbox_state(value = null):
	hurt_box.is_red = is_red
	if value == null:
		hurt_box.set_deferred("monitorable", not hurt_box.monitorable)
		hurt_box.set_deferred("monitoring", not hurt_box.monitoring)
	else:
		hurt_box.set_deferred("monitorable", value)
		hurt_box.set_deferred("monitoring", value)
