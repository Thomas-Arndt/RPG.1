extends Control

export var health = 4 setget set_health
export var max_health = 4 setget set_max_health

onready var healthFill = $Fill

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")

func set_health(value):
	health = clamp(value, 0, max_health)
	var maxHealthPercent: float = 100 / max_health
	healthFill.rect_size.x = health * maxHealthPercent

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)