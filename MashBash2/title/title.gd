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
	$Menu/AnimationPlayer.play("titleAnimation")
func _input(event):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			drawRipple(get_global_mouse_position())

func play_focus(node):
	#hoverShader.visible=true
	node="./Menu/%s"%node
	hoverShader.size=get_node(node).size+Vector2(2,2)
	hoverShader.global_position=get_node(node).global_position
	get_node(node).grab_focus()
#	Sounds.playSound("select",-20.0)


func pressPlay():
	
	Pausemenu.beginGame=Time.get_unix_time_from_system()
	Transitions.transitionScene("res://World/introScene.tscn")
#	Transitions.transitionScene("res://World/level0.tscn")
	


func _on_settings_pressed():
	$Menu/settings.queue_free()
	Sound.play("no_man_voice")


func _on_fullscreen_toggled(button_pressed):
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

const rippleTexture=preload("res://flyingBot/hoverparticle.png")
func drawRipple(location:Vector2):
	var rippleSprite=Sprite2D.new()
	rippleSprite.top_level=true;rippleSprite.position=location;rippleSprite.texture=rippleTexture
	add_child(rippleSprite);
	var tween:Tween=create_tween()
	tween.tween_property(rippleSprite,"scale",Vector2(8,8),0.75)
	tween.parallel().tween_property(rippleSprite,"modulate",Color(1,1,1,0),0.75)
	tween.tween_callback(rippleSprite.queue_free)
	


