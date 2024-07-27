extends Node2D

const void_mote = preload("res://Enemies/VoidMoteChase.tscn")

export var circle_radius = 50

onready var pivot = $Pivot
onready var radius = $Pivot/Radius
onready var timer = $Timer

var mote_container = null
var active = false

func _ready():
	mote_container = get_tree().get_nodes_in_group("MoteContainer")[0]
	assert(mote_container)
	radius.position.y += circle_radius

func throw_mote(location = null):
	if active and len(mote_container.get_children()) < mote_container.max_motes:
		var pivot_rotation = randi() % 360
		var pivot_radius = rand_range(25, 50)
		radius.position = pivot.position
		radius.position.y += pivot_radius
		pivot.rotation_degrees += pivot_rotation
		var new_mote = void_mote.instance()
		mote_container.add_child(new_mote)
		new_mote.global_position = global_position
		start_timer(rand_range(0.2, 2))

func set_active(value):
	active = value

func start_timer(time):
	timer.start(time)

func _on_Timer_timeout():
	throw_mote()
