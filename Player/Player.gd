extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var knockback = Vector2()

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var sword_hit_box = $HitBoxPivot/SwordHitBox
onready var hurt_box = $HurtBox
onready var blink_anim_player = $BlinkAnimationPlayer
onready var detection_zone = $DetectionZone/DetectionZone

onready var RedDimension = get_node("/root/Game/World/RedDimension")
onready var GreenDimension = get_node("/root/Game/World/GreenDimension")

func _ready():

	anim_tree.active = true
	anim_player.play("SETUP")
	anim_tree.set("parameters/roll/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/attack/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/idle/blend_position", WorldStats.player_spawn_direction)
	sword_hit_box.knockback_vector = roll_vector
	PlayerStats.connect("no_health", self, "_on_PlayerStats_no_health")
	
func _physics_process(delta):

	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		if detection_zone.target is InteractionZone and detection_zone.can_interact() and UI.TextBox.complete:
			detection_zone.target.start_interaction(self)
		elif UI.TextBox.complete:
			state = ATTACK
	
	if Input.is_action_just_pressed("d_shift") and WorldStats.DIMENSION == false:
		WorldStats.shift_dimension()
		RedDimension.visible = true
		GreenDimension.visible = false
	elif Input.is_action_just_pressed("d_shift") and WorldStats.DIMENSION == true:
		WorldStats.shift_dimension()
		GreenDimension.visible = true
		RedDimension.visible = false

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hit_box.knockback_vector = input_vector
		anim_tree.set("parameters/idle/blend_position", input_vector)
		anim_tree.set("parameters/run/blend_position", input_vector)
		anim_tree.set("parameters/roll/blend_position", input_vector)
		anim_tree.set("parameters/attack/blend_position", input_vector)
		anim_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		anim_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	anim_state.travel("roll")
	move()
	
func attack_state():
	velocity = Vector2.ZERO
	anim_state.travel("attack")

func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	PlayerStats.change_health(-area.damage)
	area.set_knockback_vector(self) 
	knockback = area.knockback_vector * 130
	hurt_box.start_invincible(0.6)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")

func _on_PlayerStats_no_health():
	queue_free()

func spawn_player():
	global_position = WorldStats.player_spawn_vector
	anim_tree.set("parameters/roll/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/attack/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/idle/blend_position", WorldStats.player_spawn_direction)
