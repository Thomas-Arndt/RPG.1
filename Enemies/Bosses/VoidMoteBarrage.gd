extends Node2D


const void_mote = preload("res://Enemies/VoidMote.tscn")

export var circle_radius = 50

var mote_quantity = 0
var mote_count = 0

onready var pivot = $Pivot
onready var radius = $Pivot/Radius
onready var void_motes = $VoidMotes
onready var timer = $Timer

func _ready():
	radius.position.y += circle_radius

func circle(quantity):
	mote_quantity = quantity
	var new_mote = void_mote.instance()
	new_mote.connect("timer_timeout", self, "check_mote_count")
	void_motes.add_child(new_mote)
	new_mote.global_position = global_position
	new_mote.throw(radius.global_position)
	pivot.rotation_degrees += (360/quantity)
	mote_count += 1
	timer.start(0.15)

func _process(delta):
	if len(void_motes.get_children()) == 0:
		queue_free()


func _on_Timer_timeout():
	if mote_count < mote_quantity:
		circle(mote_quantity)
