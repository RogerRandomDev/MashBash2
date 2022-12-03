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


func _on_button_pressed():
	Word.storedWords=[]
	Transitions.transitionScene("")
