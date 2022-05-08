extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var RedDimension = get_node("/root/World/RedDimension")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select") and RedDimension.visible == false:
		RedDimension.visible = true
	elif Input.is_action_just_pressed("ui_select") and RedDimension.visible == true:
		RedDimension.visible = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
