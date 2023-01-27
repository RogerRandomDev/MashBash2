extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Link.link_root.is_host:
		Link.link_root.local=$Player
		Link.link_root.target=$Client
	else:
		Link.link_root.local=$Client
		Link.link_root.target=$Player
		var camera=$Player/Camera2D
		#swaps camera from player to the flying bot if that is the one being controlled
		$Player.remove_child(camera)
		$Client/flyingBotPosition.add_child(camera)
	Word.storedWords.append("open")

func _process(delta):
	Link.link_root.send("update_parameter",['global_position',Link.link_root.local.global_position],Link.link_root)
