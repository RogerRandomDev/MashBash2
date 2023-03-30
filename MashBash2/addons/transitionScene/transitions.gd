extends CanvasLayer
var toScene=""
@rpc("authority")
func transitionScene(target,sent=false):
	if(Link.link_root&&Link.link_root.is_host):Link.link_root.send("transitionScene",[target,true],self)
	elif(Link.link_root&&!sent):return
	toScene=target
	get_tree().paused=true;Pausemenu.canPause=false
	Pausemenu.visible=false
	$AnimationPlayer.play("load")

func _process(delta):if toScene!="":Pausemenu.pausedFor+=delta

func finishLoadScene():
	Word.storedWords=[]
	if toScene=="":get_tree().reload_current_scene()
	else:get_tree().change_scene_to_file(toScene)
	toScene=""

func playScene():
	get_tree().paused=false;Pausemenu.canPause=true
