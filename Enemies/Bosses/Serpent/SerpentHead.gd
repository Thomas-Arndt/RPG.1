extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 200
export var FRICTION = 500


onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf

var segment = preload("res://Enemies/Bosses/Serpent/SerpentSegment.tscn")

var segments : int = 0

var next_segment : Node = null
var runner : Node = self

var velocity = Vector2.ZERO

func _physics_process(delta):
	if false:
		var input_vector = get_input_vector()
		
		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			flip_sprites()
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move()
		
	if next_segment != null:
		next_segment.follow_the_leader(global_position, delta)

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector
	
func move():
	velocity = move_and_slide(velocity)

func build_serpent():
	runner = self
	var count = 0
	while count < segments:
		count+=1
		var new_segment = segment.instance()
		new_segment.position = Vector2(runner.position.x + 30, runner.position.y)
		new_segment.previous_segment = runner
		runner.next_segment = new_segment
		get_parent().add_child(new_segment)
		runner = new_segment

func is_head():
	return true
	
func flip_sprites():
	red_sprite_full.flip_h = velocity.x > 0
	red_sprite_half.flip_h = velocity.x > 0
	green_sprite_full.flip_h = velocity.x > 0
	green_sprite_half.flip_h = velocity.x > 0
