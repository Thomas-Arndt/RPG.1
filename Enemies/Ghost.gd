extends KinematicBody2D

signal died(node)

const FRICTION = 200

export var is_red : bool = false

onready var anim_player = $AnimationPlayer
onready var blink_anim_player = $BlinkAnimationPlayer
onready var timer = $Timer
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
var DeathEffect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	anim_player.play("idle")
	timer.start(2)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
func apparate():
	anim_player.queue("apparate")
	anim_player.queue("idle")
	collision_shape.disabled = false
	tangible = true

func disapparate():
	knockback = Vector2.ZERO
	anim_player.stop()
	anim_player.play("disapparate")
	collision_shape.disabled = true
	tangible = false
	
func _on_Timer_timeout():
	if tangible:
		disapparate()
	else:
		apparition_controller.update_target_position()
		global_position = apparition_controller.target_position
		apparate()
	
func disapparated():
	timer.start(0.6)

func apparated():
	timer.start(2)
	
func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 100
	hurt_box.start_invincible(0.4)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")

func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")

func _on_Stats_no_health():
	emit_signal("died", self)
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)

func match_dimension(state):
	red_full_sprite.visible = false
	red_half_sprite.visible = false
	green_full_sprite.visible = false
	green_half_sprite.visible = false
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
