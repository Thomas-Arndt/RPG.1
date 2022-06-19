extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_SPEED = 35
export var FRICTION = 200
export var WANDER_BUFFER = 4

enum {
	IDLE,
	WANDER,
}

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var wander_controller = $XYWanderController

var velocity = Vector2.ZERO
var state = IDLE

func _ready():
	anim_tree.active = true
	anim_player.play("SETUP")
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	match state:
		IDLE:
			anim_state.travel("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			if wander_controller.get_time_left() == 0:
				update_wander()
		WANDER:
			if wander_controller.get_time_left() == 0:
				update_wander()
			anim_state.travel("walk")
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_BUFFER:
				update_wander()
				
	velocity = move_and_slide(velocity)
	
func update_wander():

	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(7)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	anim_tree.set("parameters/idle/blend_position", direction)
	anim_tree.set("parameters/walk/blend_position", direction)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
