extends Node

export var signal_code : String

var amplitude = 0
var priority = 0
var is_shaking : bool = false

onready var camera = get_parent()
onready var tween = $Tween

func _ready():
	SignalBus.connect("screen_shake", self, "start")
	SignalBus.connect("stop_camera_effect", self, "stop")

func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if (priority >= self.priority and not is_shaking):
		self.is_shaking = true
		self.priority = priority
		self.amplitude = amplitude

		$Frequency.wait_time = 1 / float(frequency)
		if duration > 0:
			$Duration.wait_time = duration
			$Duration.start()
		$Frequency.start()

		_new_shake()

func stop(code):
	if code == signal_code:
		_on_Duration_timeout()

func _new_shake():
	var rand = Vector2.ZERO
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	tween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _reset():
	tween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

	priority = 0

func _on_Duration_timeout() -> void:
	_reset()
	$Frequency.stop()
	self.is_shaking = false

func _on_Frequency_timeout() -> void:
	_new_shake()
