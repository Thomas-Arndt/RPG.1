extends StaticBody2D
class_name Chest

onready var interaction_zone = $InteractionZone
onready var action = $InteractionZone/Actions/ChestAction
onready var anim_player = $AnimationPlayer

func _ready():
	action.connect("started", self, "_on_Interaction_started")
	interaction_zone.connect("interaction_finished", self, "_on_Interaction_finished")
	
func _on_Interaction_started():
	if !action.locked:
		anim_player.play("open")

func _on_Interaction_finished(node):
	pass
