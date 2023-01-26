extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Link.link_root.is_host:
		Link.link_root.local=$Player
		Link.link_root.target=$flyingBotPosition
	else:
		Link.link_root.local=$flyingBotPosition
		Link.link_root.target=$Player
