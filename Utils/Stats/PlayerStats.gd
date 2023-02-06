extends Node

export(int) var max_health setget set_max_health
var health: int setget set_health
var experience: int = 0 setget set_experience
var playerLevel: int = 1 setget set_player_level

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal experience_changed(value)
signal player_level_changed(value)

func _ready():
	set_max_health(10)
	set_health(10)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func change_health(value):
	health += value
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func set_experience(value):
	experience = value
	emit_signal("experience_changed", experience)

func change_experience(value):
	experience += value
	calculate_player_level()
	emit_signal("experience_changed", experience)

func set_player_level(value):
	playerLevel = value
	emit_signal("player_level_changed", playerLevel)

func calculate_player_level():
	playerLevel = floor(experience / 40) + 1

func has_weapon_equipped():
	for i in range(4):
		if Inventory.inventory[i] != null and Inventory.inventory[i].type == "weapon":
			return true
	return false
