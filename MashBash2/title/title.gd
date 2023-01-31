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
	Pausemenu.get_node("Controls/Client").visible=false
	$Menu/AnimationPlayer.play("titleAnimation")


#used to draw a ripple wherever the mouse is clicked
func _input(event):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			drawRipple(get_global_mouse_position())


#not used much, moves the hovered rect over the hovered button
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
	

#originally a joke, just ignore it
func _on_settings_pressed():
	$Menu/settings.queue_free()
	#Sound.play("no_man_voice")

#toggles fullscreen for the game
func _on_fullscreen_toggled(button_pressed):
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


#ripple effect for when you click that dissapears after a few moments
const rippleTexture=preload("res://flyingBot/hoverparticle.png")
func drawRipple(location:Vector2):
	var rippleSprite=Sprite2D.new()
	rippleSprite.top_level=true;rippleSprite.position=location;rippleSprite.texture=rippleTexture
	add_child(rippleSprite);
	var tween:Tween=create_tween()
	tween.tween_property(rippleSprite,"scale",Vector2(8,8),0.75)
	tween.parallel().tween_property(rippleSprite,"modulate",Color(1,1,1,0),0.75)
	tween.tween_callback(rippleSprite.queue_free)
	




func _on_quit_pressed():get_tree().quit()


func _on_credits_pressed():
	$itemsAnimations.play("toggleCredits")


func _on_back():
	$itemsAnimations.play_backwards("toggleCredits")

func _on_controls_pressed():
	$itemsAnimations.play("toggleControls")

func _on_backControls_pressed():
	$itemsAnimations.play_backwards("toggleControls")


func _on_multiplayer_pressed():
	$multiplayer/VBoxContainer/connectIP.text=""
	$itemsAnimations.play("toggleMultiplayer")


func _on_multiplayerBack_pressed():
	$itemsAnimations.play_backwards("toggleMultiplayer")
	$multiplayer.resetMode()
	



