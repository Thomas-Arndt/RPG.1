extends Node2D

const bat = preload("res://Enemies/Bat.tscn")
const enter_effect = preload("res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn")
const player_detection_zone = preload("res://Utils/Overlap/PlayerDetectionZone.tscn")

onready var timer = $Timer
onready var pivot = $Pivot
onready var radius = $Pivot/Radius
onready var hop_controller = $HopController

export var bats_on : bool = true
export var blobs_on : bool = true
export var ghosts_on : bool = false
export var max_mobs : int = 3
export var min_distance : int = 25

var spawned_mobs = 0
var active_mobs = []
var pdz : Node = null

func _ready():
	randomize()
	timer.start(6)

func _on_Timer_timeout():
	var interval = 5.0
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player.is_running() and spawned_mobs == 0:
		print("Fight!")
		hop_controller.package_choreography()
		hop_controller.run_cut_scene()
		yield(hop_controller, "finished")
		spawn_mobs(player)
		interval = rand_range(10, 35)
	else:
		print("Evade")
	print("Next interval set to " + str(interval) + "s")
	timer.start(interval)

func spawn_mobs(player):
	var mob_count = 0
	var bats = 0
	var blobs = 0
	var ghosts = 0
	if bats_on:
		bats = clamp(randi() % 2 + 1, 0, max_mobs - mob_count)
		mob_count += bats
	if blobs_on and mob_count < max_mobs:
		blobs = clamp(randi() + 1, 0, max_mobs - mob_count)
		mob_count += blobs
	if ghosts_on and mob_count < max_mobs:
		ghosts = clamp(randi() % 2 + 1, 0, max_mobs - mob_count)
		mob_count += ghosts
	
	pivot.global_position = player.global_position
	reset_pivot_and_radius()
	
	var direction = randi() % 360
	for bat in bats:
		direction = spawn_mob(mobs.bat, direction, bats)
	direction = randi() % 360
	for blob in blobs:
		direction = spawn_mob(mobs.blob, direction, blobs)
	direction = randi() % 360
	for ghost in ghosts:
		direction = spawn_mob(mobs.ghost, direction, ghosts)
	
	pdz = player_detection_zone.instance()
	pdz.global_position = pivot.global_position
	pdz.connect("player_exited", self, "_on_Player_exited_pdz")
	add_child(pdz)
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 420
	pdz.set_collision_shape(circle_shape)

func spawn_mob(mob, direction, quantity):
	pivot.rotation_degrees = 0
	radius.position.y = min_distance + rand_range(25, 45)
	pivot.rotation_degrees = direction
	var new_mob = mob.instance()
	new_mob.global_position = radius.global_position
	new_mob.connect("died", self, "_on_spawn_died")
	get_parent().add_child(new_mob)
	spawned_mobs += 1
	active_mobs.append(new_mob)
	direction += 360 / quantity
	if direction >= 360:
		direction -= 360
	return direction

func reset_pivot_and_radius():
	pivot.rotation_degrees = 0
	radius.position = Vector2.ZERO

func _on_spawn_died(node):
	spawned_mobs -= 1
	active_mobs.erase(node)
	if spawned_mobs == 0:
		pdz.queue_free()

func _on_Player_exited_pdz(player):
	for mob in active_mobs:
		mob.leave_dimension()
	spawned_mobs = 0
	active_mobs = []
	pdz.queue_free()

const mobs = {
	"bat" : preload("res://Enemies/Bat.tscn"),
	"blob" : preload("res://Enemies/VoidBlob.tscn"),
	"ghost" : preload("res://Enemies/Ghost.tscn")
}
