extends KinematicBody2D

signal died(node)

const FRICTION = 200

enum ghost_ball_stages {
	PAUSE,
	CREATE,
	ACTIVATE
}

export var is_red : bool = false

onready var anim_player = $AnimationPlayer
onready var blink_anim_player = $BlinkAnimationPlayer
onready var apparition_timer = $ApparitionTimer
onready var ghost_ball_timer = $GhostBallTimer
onready var collision_shape = $CollisionShape2D
onready var apparition_controller = $InlineApparitionController
onready var stats = $Stats
onready var hurt_box = $HurtBox

onready var green_full_sprite = $GreenFullSprite
onready var green_half_sprite = $GreenHalfSprite
onready var red_full_sprite = $RedFullSprite
onready var red_half_sprite = $RedHalfSprite

var target_position = global_position
var tangible : bool = true
var knockback = Vector2.ZERO
var death_effect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
var ghost_ball = preload("res://Effects/EnemyEffects/GhostBall.tscn")

var new_ball : Node = null
var ghost_ball_state = ghost_ball_stages.PAUSE

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	apparate()
	apparition_timer.start(2)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
func apparate():
	anim_player.queue("apparate")
	anim_player.queue("idle")
	collision_shape.disabled = false
	tangible = true
	ghost_ball_timer.start(1)

func disapparate():
	knockback = Vector2.ZERO
	anim_player.stop()
	anim_player.play("disapparate")
	collision_shape.disabled = true
	tangible = false
	
func create_ghost_ball():
	var player_position = get_tree().get_nodes_in_group("Player")[0].global_position
	new_ball = ghost_ball.instance()
	new_ball.global_position = global_position + (global_position.direction_to(player_position) * 5)
	get_parent().add_child(new_ball)

func activate_ghost_ball():
	if is_instance_valid(new_ball):
		var player_position = get_tree().get_nodes_in_group("Player")[0].global_position
		var direction = new_ball.global_position.direction_to(player_position)
		new_ball.velocity = direction * new_ball.speed
		new_ball = null
	
func _on_ApparitionTimer_timeout():
	if tangible:
		disapparate()
	else:
		apparition_controller.update_target_position()
		global_position = apparition_controller.target_position
		apparate()

func _on_GhostBallTimer_timeout():
	ghost_ball_state_machine()

func ghost_ball_state_machine():
	match ghost_ball_state:
		ghost_ball_stages.PAUSE:
			ghost_ball_state = ghost_ball_stages.CREATE
			ghost_ball_timer.start(1)
		ghost_ball_stages.CREATE:
			ghost_ball_state = ghost_ball_stages.ACTIVATE
			create_ghost_ball()
			ghost_ball_timer.start(0.35)
		ghost_ball_stages.ACTIVATE:
			ghost_ball_state = ghost_ball_stages.PAUSE
			activate_ghost_ball()
	
func disapparated():
	apparition_timer.start(2)

func apparated():
	apparition_timer.start(3)
	
func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 100
	hurt_box.create_hit_effect()
	hurt_box.start_invincible(0.4)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")

func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")

func _on_Stats_no_health():
	emit_signal("died", self)
	SignalBus.emit_signal("drop_item", global_position, [[3, 0.8], [2, 0.1], [5, 0.1]], null, null, Inventory.ItemResources.MUON_PEARL)
	queue_free()
	if is_instance_valid(new_ball):
		new_ball.queue_free()
	var death_fx = ResourceLoader.load(death_effect)
	var effect = death_fx.instance()
	effect.global_position = Vector2(global_position.x, global_position.y-12)
	get_parent().add_child(effect)

func leave_dimension():
	queue_free()
	if is_instance_valid(new_ball):
		new_ball.queue_free()
	var death_fx = ResourceLoader.load(death_effect)
	var effect = death_fx.instance()
	effect.global_position = Vector2(global_position.x, global_position.y-12)
	get_parent().add_child(effect)

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
		death_effect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif is_red and not state == WorldStats.Dimensions.Red:
		red_half_sprite.visible = true
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		death_effect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif not is_red and state == WorldStats.Dimensions.Green:
		green_full_sprite.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
		death_effect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
	elif not is_red and not state == WorldStats.Dimensions.Green:
		green_half_sprite.visible = true
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		death_effect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"


