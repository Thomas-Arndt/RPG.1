extends "res://World/Objects/StaticWorldComponent.gd"

onready var interaction_zone = $InteractionZone

func _ready():
	interaction_zone.text = [
		"        ~~ NOTICE TO TRAVELERS ~~",
		"Blob season is in full swing, and the danger is real.",
		"Remember these three things:",
		"1. Give them space and they will leave you alone.",
		"2. See-through? They can still hurt you.",
		"3. Keep away when they explode."
	]
