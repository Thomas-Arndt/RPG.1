extends Node2D
class_name ProximitySpawnController

signal spawn_died

export var spawn_unit: PackedScene
export var spawn_interval: float = 60
export var spawn_quantity: int = 1
export var quest_reference: PackedScene
export var is_red: bool = false

onready var timer = $Timer
onready var player_detection_zone = $PlayerDetectionZone

var quest = null
var spawn_count = 0

func _ready():
	player_detection_zone.connect("player_detected", self, "player_detected")
	if quest_reference != null:
		quest = QuestSystem.find_available(quest_reference.instance())
		if quest == null:
			quest = QuestSystem.active_quests.find(quest_reference.instance())
		if quest == null:
			quest = QuestSystem.completed_quests.find(quest_reference.instance())

func check_spawn():
	if spawn_count < spawn_quantity:
		spawn_new_unit()

func spawn_new_unit():
	if spawn_unit != null:
		var new_unit = spawn_unit.instance()
		new_unit.global_position = global_position
		new_unit.connect("died", self, "_on_Spawn_died")
		if quest != null:
			for objective in quest.objectives.get_children():
				if objective is QuestSlayObjective and not objective.completed:
					new_unit.connect("died", objective, "_on_enemy_died")
		if "is_red" in new_unit:
			new_unit.is_red = is_red
		get_parent().add_child(new_unit)
		spawn_count += 1

func _on_Timer_timeout():
	if player_detection_zone.can_see_player():
		timer.start(spawn_interval)
		check_spawn()

func player_detected(player = null):
	if timer.time_left == 0:
		timer.start(spawn_interval)
		check_spawn()

func _on_Spawn_died(node):
	emit_signal("spawn_died")
	spawn_count -= 1

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"spawn_count" : spawn_count,
		"time_remaining" : timer.time_left
	}
	return save_dict
