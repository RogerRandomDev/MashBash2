extends CanvasLayer
var toScene=""

func transitionScene(target):
	toScene=target
	get_tree().paused=true;Pausemenu.canPause=false



func finishLoadScene():
	get_tree().change_scene(toScene)

func playScene():
	get_tree().paused=false;Pausemenu.canPause=true
