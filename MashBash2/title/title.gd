extends Control

@onready var hoverShader=$Menu/hoveredShader

func _ready():
	#resets menu scale so i don't have to
	#$Menu/play.scale*=0;$Menu/settings.scale*=0;$Menu/quit.scale*=0
	$Menu.visible=false
	$AnimationPlayer.play("load")
	Sound.playSong("song1")
	#focuses on the play button
	Pausemenu.get_node("Controls/Movement").visible=false
	Pausemenu.get_node("Controls/Interact").visible=false
	Pausemenu.get_node("Controls/ClosePause").visible=false
	Pausemenu.get_node("Controls/Vacuum").visible=false
	


func play_focus(node):
	hoverShader.visible=true
	node="./Menu/%s"%node
	hoverShader.size=get_node(node).size+Vector2(2,2)
	hoverShader.position=get_node(node).position
	get_node(node).grab_focus()


func pressPlay():
	Pausemenu.get_node("CanvasLayer").visible=true
	Pausemenu.beginGame=Time.get_unix_time_from_system()
	Transitions.transitionScene("res://World/level0.tscn")
	


func _on_settings_pressed():
	$Menu/settings.queue_free()
	Sound.play("no_man_voice")


func _on_fullscreen_toggled(button_pressed):
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
