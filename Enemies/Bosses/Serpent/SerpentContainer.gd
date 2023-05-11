extends YSort

export var segments : int = 0

onready var head : Node = $SerpentHead

func _ready():
	head.segments = segments
	head.build_serpent()
