extends KinematicBody2D
class_name SliderTrap

export var ACCELERATION = 200
export var MOVE_SPEED = 100
export var ATTACK_SPEED = 300
export var RETRACT_SPEED = 75
export var FRICTION = 200
export var state_machine_paused = false

enum {
	IDLE,
	MOVE,
	ACTIVATE,
	ATTACK,
	RETRACT,
	DEACTIVATE,
}

var velocity: Vector2 = Vector2.ZERO
var state = IDLE
var player : Node
var alignment : String
var attack_starting_position: Vector2
var attack_direction : Vector2
var test_timer = 100

onready var anim_player = $AnimationPlayer
onready var wander_controller = $DetectionWanderController
onready var player_detection_zone = $Node/PlayerDetectionZone
onready var collision = $CollisionPolygon2D

func _ready():
	anim_player.play("RESET")
	$CollisionDetector.connect("collision_detected", self, "_on_Collision_Detected")
	wander_controller.start_timer(0.1)
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	wander_controller.set_position(wander_controller.start_position)
	if !state_machine_paused:
		match state:
			IDLE:
				if wander_controller.get_time_left() == 0:
					state = MOVE
			MOVE:
				accelerate_towards_point(wander_controller.target_position, MOVE_SPEED, delta)
				if wander_controller.can_see_unit():
					wander_controller.target_position = global_position
					velocity = Vector2.ZERO
					wander_controller.start_timer(1)
					state = IDLE
				if player_detection_zone.can_see_player():
					if global_position.x <= player.global_position.x + 3 and global_position.x >= player.global_position.x - 3:
						alignment = "y"
						state = ACTIVATE
					if global_position.y <= player.global_position.y + 3 and global_position.y >= player.global_position.y - 3:
						alignment = "x"
						state = ACTIVATE
			ACTIVATE:
				velocity = Vector2.ZERO
				attack_starting_position = global_position
				if global_position.y < player.global_position.y and alignment == "y":
					attack_direction = Vector2.DOWN
					anim_player.play("activate_down")
				elif global_position.y > player.global_position.y and alignment == "y":
					attack_direction = Vector2.UP
					anim_player.play("activate_up")
				elif global_position.x < player.global_position.x and alignment == "x":
					attack_direction = Vector2.RIGHT
					anim_player.play("activate_right")
				elif global_position.x > player.global_position.x and alignment == "x":
					attack_direction = Vector2.LEFT
					anim_player.play("activate_left")
			ATTACK:
				velocity = velocity.move_toward(attack_direction * ATTACK_SPEED, FRICTION*2.5 * delta)
			RETRACT:
				accelerate_towards_point(attack_starting_position, RETRACT_SPEED, delta)
				if abs(global_position.x - attack_starting_position.x) <= 1 and abs(global_position.y - attack_starting_position.y) <= 1:
					velocity = Vector2.ZERO
					state = DEACTIVATE
			DEACTIVATE:
				match attack_direction:
					Vector2.DOWN:
						anim_player.play("deactivate_down")
					Vector2.UP:
						anim_player.play("deactivate_up")
					Vector2.RIGHT:
						anim_player.play("deactivate_right")
					Vector2.LEFT:
						anim_player.play("deactivate_left")
				attack_direction = Vector2.ZERO
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, speed,  delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, FRICTION * delta)
	
func state_machine_pause():
	state_machine_paused = true

func state_machine_run():
	state_machine_paused = false
	state = IDLE
	
func attack():
	state = ATTACK

func move():
	state = MOVE

func _on_Collision_Detected(object):
	if state == ATTACK:
		velocity = Vector2.ZERO
		state = RETRACT
