extends CanvasLayer
var canPause=true
var showgate=null
func _ready():
	showgate=$logic/showgates
func _input(_event):
	if !canPause||get_tree().current_scene.name=="title":return
	if Input.is_action_just_pressed("exit"):
		visible=!visible;get_tree().paused=visible
