extends CanvasLayer

onready var quest_list_container : Node = $ScrollContainer/VBoxContainer
onready var description : Node = $Description
onready var gold_icon : Node = $GoldIcon
onready var gold_reward : Node = $GoldReward
onready var item_rewards_container : Node = $ItemRewards
onready var frame : Node = $Frame
onready var scroll_container : Node = $ScrollContainer
onready var rewards_label : Node = $RewardsLabel

var quest_log_label = preload("res://UI/QuestLog/QuestLogLabel.tscn")

var quest_log : Array
var quest_cursor : int = 0
var show: bool = false

func _process(delta):
	if show:
		if Input.is_action_just_pressed("ui_up"):
			update_cursor_index(-1)
		if Input.is_action_just_pressed("ui_down"):
			update_cursor_index(1)

func get_quest_log():
	quest_log = QuestSystem.get_quest_log()

func build_quest_log():
	for item in quest_list_container.get_children():
		item.queue_free()
	description.text = "You have no quests."
	if len(quest_log) > 0:
		for quest in quest_log:
			var quest_label = quest_log_label.instance()
			quest_label.text = quest.title
			quest_list_container.add_child(quest_label)

func update_cursor_index(change):
	quest_cursor = clamp(quest_cursor + change, 0, quest_list_container.get_child_count()-1)
	highlight_active_row()
	display_quest_details()

func highlight_active_row():
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0.518, 0.493, 0.528, 1.0))
	for index in quest_list_container.get_child_count():
		var child = quest_list_container.get_child(index)
		if index == quest_cursor:
			child.set("custom_styles/normal", style)
		else:
			child.set("custom_styles/normal", null)

func display_quest_details():
	description.text = quest_log[quest_cursor].description
	for obj in quest_log[quest_cursor].objectives:
		if "amount" in obj:
			description.text += "\n\n" + str(obj.amount) + " remaining"
	gold_reward.text = str(quest_log[quest_cursor].rewards["gold"])

func show_hide_quest_log():
	show = !show
	if show:
		get_quest_log()
		build_quest_log()
	quest_cursor = 0
	print(quest_log)
	if len(quest_log) > 0:
		highlight_active_row()
		display_quest_details()
	set_visibility(show)
	
func set_visibility(value):
	frame.set_deferred("visible", show)
	scroll_container.set_deferred("visible", show)
	description.set_deferred("visible", show)
	rewards_label.set_deferred("visible", show)
	gold_icon.set_deferred("visible", show)
	gold_reward.set_deferred("visible", show)
	item_rewards_container.set_deferred("visible", show)

func hide():
	set_visibility(false)
