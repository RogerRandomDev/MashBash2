@tool
extends Resource
class_name eventResource
#editactions lets us use an enum
#otherwise it can be hell on earth to do it
@export var Actions:PackedInt32Array:
	set(value):
		Actions=value
		updateValues()
	get:return Actions
@export var ActionValues:Array


func updateValues():
	
	#resizes
	if Actions.size()!=ActionValues.size():ActionValues.resize(Actions.size())
	#makes the value valid for what we want
	
	#makes sure all actions have the right corresponding input type
	for _action in Actions.size():
		var act=Actions[_action]
		if Mashlogue.ActionVariableType[act*2]==typeof(ActionValues[_action]):continue
		ActionValues[_action]=getActionVar(act)
		

#triggers the actions for itself
func trigger():
	for action in Actions.size():call(Mashlogue.Actions.keys()[Actions[action]],ActionValues[action])


#returns variable type from string reference
#very useful for the purpose I gave it
func getActionVar(_actionId):
	var inp=Mashlogue.ActionVariableType[_actionId*2+1]
	var out=str2var(inp)
	if out==null&&inp!="null":return inp
	return out

#should set cell in current level tilemap
func SetCell(_cell):pass

#causes camera shake
func ShakeCamera(_active):pass

#moves the camera
func MoveCamera(_position):pass

#resets camera position
func ResetCamera(_null):pass

#changes current talker in dialogue
func ChangeSpeaker(_speaker):
	Mashlogue.swapIcons(load("res://addons/MASHLOG/iconsets/%s.tres"%_speaker))
