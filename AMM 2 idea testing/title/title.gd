extends Control

@onready var hoverShader=$Menu/hoveredShader

func _ready():
	#resets menu scale so i don't have to
	$Menu/play.scale*=0;$Menu/settings.scale*=0;$Menu/quit.scale*=0
	Sound.playSong("song1")
	$AnimationPlayer.play("load")
	#focuses on the play button
	


func play_focus(node):
	hoverShader.visible=true
	node="./Menu/%s"%node
	hoverShader.size=get_node(node).size+Vector2(2,2)
	hoverShader.position=get_node(node).position
	get_node(node).grab_focus()


func pressPlay():
	get_tree().change_scene("res://World/level0.tscn")
