extends KinematicBody2D
class_name Player

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK,
	PUSH,
	MINE
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var knockback = Vector2()
var is_running = true
var active : bool = true
var last_action = null

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var sword_hit_box = $HitBoxPivot/SwordHitBox
onready var hurt_box = $HurtBox
onready var blink_anim_player = $BlinkAnimationPlayer
onready var detection_zone = $DetectionZone/DetectionZone
onready var push_detection_zone = $PushDetectionZone/PushDetectionZone
onready var weapon_sprite = $WeaponSprite
onready var sprite = $Sprite

func _ready():
	anim_tree.active = true
	anim_player.play("SETUP")
	anim_tree.set("parameters/roll/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/attack/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/idle/blend_position", WorldStats.player_spawn_direction)
	anim_tree.set("parameters/push/blend_position", WorldStats.player_spawn_direction)
	sword_hit_box.knockback_vector = roll_vector
	PlayerStats.connect("no_health", self, "_on_PlayerStats_no_health")
	push_detection_zone.connect("is_colliding", self, "push_zone_entered")
	
func _physics_process(delta):
	if not active:
		return

	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		PUSH:
			push_state(delta)
		MINE:
			mine_state()
	
	if Input.is_action_just_pressed("quick_action_1"):
		process_action(0)
	if Input.is_action_just_pressed("quick_action_2"):
		process_action(1)
	if Input.is_action_just_pressed("quick_action_3"):
		process_action(2)
	if Input.is_action_just_pressed("quick_action_4"):
		process_action(3)
	
	if Input.is_action_just_pressed("backpack") and UI.TextBox.complete:
		is_running = !is_running
		UI.Backpack.toggle_backpack()
		
	if Input.is_action_just_pressed("crafting") and UI.TextBox.complete:
		if not UI.Backpack.state and not UI.Backpack.crafting:
			is_running = !is_running
		UI.Backpack.toggle_crafting_menu()
	
	if Input.is_action_just_pressed("quest_log") and UI.TextBox.complete:
		is_running = !is_running
		UI.QuestLog.show_hide_quest_log()
	
	# Debug Input Key
	if Input.is_action_just_pressed("debug"):
		pass
	if Input.is_action_just_released("debug"):
		pass
	
func move_state(delta):
	hide_weapon()
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO and is_running:
		apply_input_vector(input_vector)
		anim_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		anim_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func push_state(delta):
	hide_weapon()
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO and is_running:
		if input_vector == roll_vector:
			apply_input_vector(input_vector)
			anim_state.travel("push")
			velocity = velocity.move_toward(input_vector * (MAX_SPEED/5), ACCELERATION * delta)
			if push_detection_zone.has_target():
				push_detection_zone.target.move(velocity)
		else:
			anim_state.travel("idle")
			state = MOVE
	else:
		anim_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
func roll_state():
	if is_running:
		hide_weapon()
		velocity = roll_vector * ROLL_SPEED
		anim_state.travel("roll")
		move()
	
func attack_state():
	velocity = Vector2.ZERO
	anim_state.travel("attack")

func mine_state():
	if Input.is_action_just_released(get_last_input()):
		state = MOVE
	else:
		hide_weapon()
		velocity = Vector2.ZERO
		anim_state.travel("mine")
	
func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func apply_input_vector(input_vector):
	roll_vector = input_vector
	sword_hit_box.knockback_vector = input_vector
	anim_tree.set("parameters/idle/blend_position", input_vector)
	anim_tree.set("parameters/run/blend_position", input_vector)
	anim_tree.set("parameters/roll/blend_position", input_vector)
	anim_tree.set("parameters/attack/blend_position", input_vector)
	anim_tree.set("parameters/push/blend_position", input_vector)
	anim_tree.set("parameters/mine/blend_position", input_vector)

func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	hide_weapon()
	state = MOVE

func hide_weapon():
	if weapon_sprite.visible:
		weapon_sprite.visible = false

func set_weapon_sprite(weapon):
	weapon_sprite.set_sprite(weapon)
	
func _on_HurtBox_area_entered(area):
	PlayerStats.change_health(-area.damage)
	area.set_knockback_vector(self) 
	knockback = area.knockback_vector * 150
	move_and_slide(knockback)
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
	anim_tree.set("parameters/push/blend_position", WorldStats.player_spawn_direction)

func paused(state):
	is_running = !state

func _on_interaction_finished(node):
	paused(false)
	
func push_zone_entered(target):
	state = PUSH
	
func process_action(index):
	if is_running:
		if index == 3 and detection_zone.target is InteractionZone and detection_zone.can_interact() and UI.TextBox.complete:
			if not can_mine_target(detection_zone.target):
				if not detection_zone.target.is_connected("interaction_finished", self, "_on_interaction_finished"):
					detection_zone.target.connect("interaction_finished", self, "_on_interaction_finished")
				paused(true)
				detection_zone.target.start_interaction(self)
		elif Inventory.inventory[index] is Item and UI.TextBox.complete:
			Inventory.inventory[index].action(self)
			last_action = index
			if Inventory.inventory[index].consumable:
				Inventory.consume_item(index)
				Inventory.emit_signal("item_changed", [index])

func state_machine_pause():
	active = false

func state_machine_run():
	active = true
	state = MOVE
	
func get_last_input():
	match last_action:
		0:
			return "quick_action_1"
		1:
			return "quick_action_2"
		2:
			return "quick_action_3"
		3:
			return "quick_action_4"

func mine_item():
	if detection_zone.target is InteractionZone and detection_zone.can_interact() and can_mine_target(detection_zone.target):
		detection_zone.target.start_interaction(self)

func can_mine_target(target):
	if target != null:
		var actions = target.Actions.get_children()
		for action in actions:
			if action is MineAction or action is MineRockAction:
				return true
		return false
