extends Control

const CHAR_READ_RATE = 0.05

export var health = 10 setget set_health
export var max_health = 10 setget set_max_health

onready var healthFill = $Fill

func _ready():
	self.set_max_health(PlayerStats.max_health)
	self.set_health(PlayerStats.max_health)
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")
	healthFill.rect_size.x = 100

func set_health(value):
	var maxHealthPercent: float = 100 / max_health
	healthFill.rect_size.x = health * maxHealthPercent
	$Tween.remove_all()
	var start_rect_x = health * maxHealthPercent
	health = clamp(value, 0, max_health)
	var end_rect_x = health * maxHealthPercent
	$Tween.interpolate_property(healthFill, "rect_size:x", start_rect_x, end_rect_x, abs(start_rect_x - end_rect_x) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
