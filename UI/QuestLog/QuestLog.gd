extends CanvasLayer

onready var quest_list_container : Node = $ScrollContainer/VBoxContainer
onready var description : Node = $Description
onready var gold_icon : Node = $GoldIcon
onready var gold_reward : Node = $GoldReward
onready var item_rewards_container : Node = $ItemRewards

var quest_log_title = preload("res://UI/QuestLog/QuestLogTitle.tscn")

var quest_log_dict : Dictionary
var quest_cursor : int = 0

func _ready():
	get_quest_log_array()
	assert(quest_log_dict)
	build_quest_log()
	
func get_quest_log_array():
	quest_log_dict = QuestSystem.get_quest_log()

func build_quest_log():
	for quest in quest_log_dict.active_quests:
		var label = quest_log_title.instance()
		label.text = quest.title
		quest_list_container.add_child(label)

func update_cursor_index(change):
	quest_cursor = clamp(quest_cursor + change, 0, quest_list_container.get_child_count()-1)
	highlight_active_row()

func highlight_active_row():
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0.518, 0.493, 0.528, 1.0))
	for index in quest_list_container.get_child_count():
		var child = quest_list_container.get_child(index)
		if index == quest_cursor:
			child.set("custom_styles/normal", style)
		else:
			child.set("custom_styles/normal", null)
