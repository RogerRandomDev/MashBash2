extends CanvasLayer
var beginGame=0.0
var endGame=0.0
var pausedFor=0.0;
var runningFor=0.0;
var canPause=true
var showgate=null
var dontTime=false
func _ready():
	showgate=$logic/showgates
#stores how many seconds the game was paused for
func _process(delta):
	if !visible&&!dontTime:runningFor+=delta;
	updateTimer();

func _input(_event):
	if !canPause||get_tree().current_scene.name=="title":return
	if Input.is_action_just_pressed("exit")&&!Word.get_node("wordswaplevel").visible:
		visible=!visible;get_tree().paused=visible
		if visible:Mashlogue._dialogueBox.process_mode=Node.PROCESS_MODE_PAUSABLE
		else:Mashlogue._dialogueBox.process_mode=Node.PROCESS_MODE_ALWAYS
		updateTimer()
		
	if visible && Input.is_key_pressed(KEY_U):
		#skipping level adds a solid 5 minutes to your time
		pausedFor-=300.0
		runningFor+=300.0
		var next=get_tree().get_first_node_in_group("endLevel")
		visible=false
		next._on_area_2d_body_entered(get_tree().get_first_node_in_group("player"));
		


func _on_button_pressed():
	Word.storedWords=[]
	Transitions.transitionScene("")
	visible=false

func updateTimer():
	var time=runningFor;
	#convert to minutes and seconds
	var minutes=int(time/60)
	var seconds=int(time)%60
	seconds = seconds+floor((runningFor-floor(runningFor))*1000)/1000
	var outputTime=("0" if minutes<10 else "")+str(minutes)+":"+("0" if seconds < 10 else "")+str(seconds)
	$CanvasLayer/Label.text=outputTime
