extends CanvasLayer
var canPause=true
var showgate=null
func _ready():
	showgate=$logic/showgates
func _input(_event):
	if !canPause||get_tree().current_scene.name=="title":return
	if Input.is_action_just_pressed("exit")&&!Word.get_node("wordswaplevel").visible:
		visible=!visible;get_tree().paused=visible
		if visible:Mashlogue._dialogueBox.process_mode=Node.PROCESS_MODE_PAUSABLE
		else:Mashlogue._dialogueBox.process_mode=Node.PROCESS_MODE_ALWAYS
	if visible && Input.is_key_pressed(KEY_U):
		var next=get_tree().get_first_node_in_group("endLevel")
		visible=false
		next._on_area_2d_body_entered(get_tree().get_first_node_in_group("player"));
		


func _on_button_pressed():
	Word.storedWords=[]
	Transitions.transitionScene("")
	visible=false
