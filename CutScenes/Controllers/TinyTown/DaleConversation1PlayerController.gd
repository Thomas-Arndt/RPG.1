extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"Wh-who's there?",
	]
	choreography.append([DIALOGUE, monologue, "Dale"])
	monologue = [
		"Loni sent you, huh? Good guy, that Loni.",
		"Is it safe out there? I've had my fill of being chased by mosters since I got back from the caverns.",
		"It is? Then a chat and a breath of fresh air sounds nice.",
	]
	choreography.append([DIALOGUE, monologue, "Dale"])
	choreography.append([WAIT, 1])
	monologue = [
		"So, you want me to tell you about what happened at the caverns? Sure! I'll tell ya.",
		"We were all there for the bi-annual Orrelsbad mushroom hunt. They only grow in Orrelsbad Caverns, and only twice a year.",
		"While everyone was inside the caves harvesting, I was keeping an eye on the ones we had drying in the sun.",
		"All of a sudden, the ground started to shake and the entrance to the cavern collapsed.",
		"At the same time, a bunch of glowing monsters appeared around me and chased me darn near all the way back here.",
		"I am not sure what happened to everyone, but I can tell you one thing...you're gonna need to do some digging to find them.",
		"Unfortunately, our digging tools were destroyed in the cave-in. We dont usually need them so we leave them by the entrance.",
		"Now if you'll excuse me, I think that is plenty of fresh air for the time being. Sorry I can't hemp more, and good luck!"
	]
	choreography.append([DIALOGUE, monologue, "Dale"])
	choreography.append([WAIT, 1])
	choreography.append([GIVE_QUEST, preload("res://QuestSystem/Quests/MQ_01_0060.tscn"), ""])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])

func custom_actions(action_name, args):
	match action_name:
		"PASS":
			pass
			
