extends YSort

onready var head : Node = $SerpentHead

func _ready():
	head.build_serpent()
