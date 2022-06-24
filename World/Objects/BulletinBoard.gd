extends "res://World/Objects/StaticWorldComponent.gd"

onready var player_detection_zone = $PlayerDetectionZone
onready var quest_bubble = $PlayerDetectionZone/QuestBubble/Sprite
onready var actions = $InteractionZone/Actions

func _process(delta):
	seek_player()
	quest_status()

func seek_player():
	if player_detection_zone.can_see_player():
		quest_bubble.visible = true
	else:
		quest_bubble.visible = false

func quest_status():
	var set = false
	var current_actions = actions.get_children()
	for action in current_actions:
		if not set:
			if action.active:
				if action is CompletedQuestAction and QuestSystem.completed_quests.find(action.quest_reference.instance()) != null:
					quest_bubble.region_rect.position = Vector2(48, 128)
					set = true
				elif action is GiveQuestAction and QuestSystem.available_quests.find(action.quest_reference.instance()) != null:
					quest_bubble.region_rect.position = Vector2(32, 128)
					set = true
				else:
					quest_bubble.region_rect.position = Vector2(128, 128)
		
