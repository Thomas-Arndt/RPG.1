extends YSort

export var segments : int = 0

onready var head : Node = $SerpentHead
onready var arena : Node = $Arena
onready var mote_container : Node = $MoteContainer
onready var timer = $Timer

var motes : Array = []
var remaining_segments : Array = []

func _ready():
	head.connect("died", self, "_on_Head_Died")
	head.segments = segments
	head.build_serpent()

func _on_Head_Died():
	get_tree().get_nodes_in_group("SerpentStampedeDoorController")[0].close_all_doors()
	motes = mote_container.get_children()
	get_segments(head.next_segment)
	var next_segment = remaining_segments.pop_front()
	if next_segment != null:
		next_segment.die()
	var mote = motes.pop_back()	
	if mote != null:
		mote.destroy()
	timer.start(0.2)

func _on_Timer_timeout():
	if len(motes) > 0:
		var mote = motes.pop_back()
		mote.destroy()
	if len(remaining_segments) > 0:
		var next_segment = remaining_segments.pop_front()
		next_segment.die()
	if len(motes) > 0 or len(remaining_segments) > 0:
		timer.start(0.2)
	else:
		SignalBus.emit_signal("add_node", "Boss_Defeated")
		

func get_segments(segment):
	if segment != null:
		remaining_segments.append(segment)
		if segment.next_segment != null:
			get_segments(segment.next_segment)
