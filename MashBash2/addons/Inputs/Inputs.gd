extends Node

var usingController=false
var screen_size:Vector2
func _ready():
	usingController=Input.get_connected_joypads().size()>0
	screen_size=Vector2(1152,648)/2
	if usingController:
		Input.mouse_mode=Input.MOUSE_MODE_CONFINED_HIDDEN

var axis=Vector2(0,0)
func _input(event):
	if !event is InputEventJoypadMotion:return
	if event.axis==3:axis.x=event.axis_value*128
	if event.axis==4:axis.y=event.axis_value*128


func _process(delta):
	if !usingController:return
	get_viewport().warp_mouse(
		axis+screen_size
	)
