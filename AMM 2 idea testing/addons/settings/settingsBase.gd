@tool
extends Node

signal recievedInput
var newKey=null

func _ready():self.process_mode=Node.PROCESS_MODE_ALWAYS

#loads latest key press
func _input(event):
	if !get_tree().paused:return
	if !(event is InputEventKey)||!event.pressed:return
	newKey=event
	emit_signal("recievedInput")


#remaps current key press
func remap(_input):
	get_tree().paused=true
	await recievedInput
	InputMap.action_erase_events(_input)
	InputMap.action_add_event(_input,newKey)
	get_tree().paused=false
	


