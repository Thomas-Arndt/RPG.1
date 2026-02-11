extends StaticBody2D
class_name HutDoor

export var show_green: bool = true
export var show_red: bool = true

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var remove_emitter = $Lock/InteractionZone/Actions/LockAction/RemoveNodeEmitter
onready var remove_receiver = $RemoveNodeReceiver

var is_open : bool = false

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	var signal_code = get_instance_id()
	remove_emitter.signal_code = str(signal_code)
	remove_receiver.signal_code = str(signal_code)
	
func open_door():
	is_open = true
	match_dimension(WorldStats.DIMENSION)

func close_door():
	is_open = false
	match_dimension(WorldStats.DIMENSION)

func match_dimension(state):
	if is_open:
		sprite.visible = false
		collision_shape.set_deferred("disabled", true)
	elif state == WorldStats.Dimensions.Red and show_red == true:
		sprite.visible = true
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Red and show_red == false:
		sprite.visible = false
		collision_shape.set_deferred("disabled", true)
	elif state == WorldStats.Dimensions.Green and show_green == true:
		sprite.visible = true
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Green and show_green == false:
		sprite.visible = false
		collision_shape.set_deferred("disabled", true)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "HutDoor",
		"is_open" : is_open,
	}
	return save_dict
