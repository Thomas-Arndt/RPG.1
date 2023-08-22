extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 200
export var FRICTION = 500


onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf
onready var stats : Node = $Stats
onready var hurt_box : Node = $HurtBox
onready var blink_anim_player : Node = $BlinkAnimationPlayer
onready var wander_controller : Node = $StampedeWanderController

var segment = preload("res://Enemies/Bosses/Serpent/SerpentSegment.tscn")

var segments : int = 0
var knockback : Vector2 = Vector2.ZERO

var next_segment : Node = null
var runner : Node = self

enum states {
	STAMPEDE,
}
var state = states.STAMPEDE

var velocity = Vector2.ZERO

func _physics_process(delta):
	wander_controller.set_position(wander_controller.start_position)
	match state:
		states.STAMPEDE:
			accelerate_towards_point(wander_controller.target_position, delta)
			if wander_controller.can_see_unit():
				wander_controller.target_position = global_position
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				wander_controller.start_timer(0.01)
			move()
		
	if next_segment != null:
		next_segment.follow_the_leader(global_position, delta)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
	
func move():
	velocity = move_and_slide(velocity)
	flip_sprites()
	
func flip_sprites():
	red_sprite_full.flip_h = velocity.x > 0
	red_sprite_half.flip_h = velocity.x > 0
	green_sprite_full.flip_h = velocity.x > 0
	green_sprite_half.flip_h = velocity.x > 0

func _on_HurtBox_area_entered(area):
	if next_segment == null:
		stats.change_health(-area.damage)
		area.set_knockback_vector(self) 
		knockback = area.knockback_vector * 130
		move_and_slide(knockback)
		hurt_box.start_invincible(0.6)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")

func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")

func _on_Stats_no_health():
	runner = self
	while runner.next_segment != null:
		runner = runner.next_segment
	while runner != self:
		runner = runner.previous_segment
		runner.next_segment.queue_free()
	queue_free()

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
	

func _on_BlobGrabber_body_entered(body):
	if body is VoidBlob:
		runner = self
		while runner.next_segment != null:
			runner = runner.next_segment
		var new_segment = segment.instance()
		var spawn_position = runner.position + runner.previous_segment.position.direction_to(runner.position).normalized() * 30
		new_segment.position = spawn_position
		runner.next_segment = new_segment
		new_segment.previous_segment = runner
		get_parent().add_child(new_segment)
		body.queue_free()
