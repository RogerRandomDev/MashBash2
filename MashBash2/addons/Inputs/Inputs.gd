extends Node

var usingController=false
func _ready():
	usingController=Input.get_connected_joypads().size()>0


func _input(event):
	if !usingController:return
	
