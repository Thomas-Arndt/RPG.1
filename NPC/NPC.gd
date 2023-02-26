extends KinematicBody2D

export var show_green: bool = true
export var show_red: bool = true
export (int) var ACCELERATION = 200
export (int) var MAX_SPEED = 35
export (int) var FRICTION = 200
export (int) var WANDER_BUFFER = 4
export (int) var WANDER_RANGE = 32
export (String) var AXIS = "X"

enum {
	IDLE,
	WANDER,
	INTERACT,
}

onready var sprite = $Sprite
onready var shadow = $ShadowSprite
onready var collision_shape = $CollisionShape2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var wander_controller = $XYWanderController
onready var interaction_zone = $InteractionZone
onready var player_detection_zone = $PlayerDetectionZone
onready var quest_bubble = $PlayerDetectionZone/QuestBubble/Sprite
onready var actions = $InteractionZone/Actions

var velocity = Vector2.ZERO
var state = IDLE
var interacting: bool = false
var interaction_target: Node = null
var active: bool = true

func _ready():
	interaction_zone.connect("interaction_started", self, "_on_Interaction_Zone_interaction_started")
	interaction_zone.connect("interaction_finished", self, "_on_Interaction_Zone_interaction_finished")
	wander_controller.wander_range = WANDER_RANGE
	wander_controller.axis = AXIS
	anim_tree.active = true
	anim_player.play("SETUP")
	state = pick_random_state([IDLE, WANDER])
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")

func _physics_process(delta):
	if active:
		seek_player()
		quest_status()
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
			INTERACT:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				anim_state.travel("idle")
				var direction = global_position.direction_to(interaction_target.global_position)
				anim_tree.set("parameters/idle/blend_position", direction)
				anim_tree.set("parameters/walk/blend_position", direction)
					
		velocity = move_and_slide(velocity)
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(5)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	anim_tree.set("parameters/idle/blend_position", direction)
	anim_tree.set("parameters/walk/blend_position", direction)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func _on_Interaction_Zone_interaction_started(node):
	interaction_target = node
	state = INTERACT
	

func _on_Interaction_Zone_interaction_finished(node):
	interaction_target = null
	state = IDLE
	

func seek_player():
	if player_detection_zone.can_see_player():
		quest_bubble.visible = true
	else:
		quest_bubble.visible = false

func quest_status():
	var current_actions = actions.get_children()
	for action in current_actions:
		if action.active:
			if action is CompletedQuestAction and QuestSystem.completed_quests.find(action.quest_reference.instance()) != null:
				quest_bubble.region_rect.position = Vector2(48, 128)
				return
			elif action is GiveQuestAction and QuestSystem.available_quests.find(action.quest_reference.instance()) != null:
				quest_bubble.region_rect.position = Vector2(32, 128)
				return
		else:
			quest_bubble.region_rect.position = Vector2(128, 128)

func match_dimension(state):
	if state == WorldStats.Dimensions.Red and show_red == true:
		active = true
		sprite.visible = true
		shadow.visible = true
		player_detection_zone.set_deferred("monitoring", true)
		interaction_zone.set_deferred("monitorable", true)
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Red and show_red == false:
		active = false
		sprite.visible = false
		shadow.visible = false
		player_detection_zone.set_deferred("monitoring", false)
		interaction_zone.set_deferred("monitorable", false)
		collision_shape.set_deferred("disabled", true)
	elif state == WorldStats.Dimensions.Green and show_green == true:
		active = true
		sprite.visible = true
		shadow.visible = true
		player_detection_zone.set_deferred("monitoring", true)
		interaction_zone.set_deferred("monitorable", true)
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Green and show_green == false:
		active = false
		sprite.visible = false
		shadow.visible = false
		player_detection_zone.set_deferred("monitoring", false)
		interaction_zone.set_deferred("monitorable", false)
		collision_shape.set_deferred("disabled", true)
