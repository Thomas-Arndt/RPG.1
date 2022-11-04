extends StaticBody2D
class_name Chest

export (bool) var locked = false
export (Resource) var loot = null
export (int) var quantity = 1

onready var interaction_zone = $InteractionZone
onready var action = $InteractionZone/Actions/CompletedQuestAction
onready var anim_player = $AnimationPlayer

func _ready():
	interaction_zone.connect("interaction_started", self, "_on_Interaction_started")
	interaction_zone.connect("interaction_finished", self, "_on_Interaction_finished")
	
func _on_Interaction_started():
	if action.active:
		anim_player.play("open")

func _on_Interaction_finished(node):
	interaction_zone.queue_free()
	if action.active:
		anim_player.play("close")
