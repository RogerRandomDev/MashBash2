extends CanvasLayer
var toScene=""

func transitionScene(target):
	toScene=target
	get_tree().paused=true;Pausemenu.canPause=false
	$AnimationPlayer.play("load")


func finishLoadScene():
	if toScene=="":get_tree().reload_current_scene()
	else:get_tree().change_scene_to_file(toScene)

func playScene():
	get_tree().paused=false;Pausemenu.canPause=true
