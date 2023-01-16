
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

var ActionVariableType:Array=[
	10,"Vector3i(0,0,0)",
	1,"true",
	5,"Vector2(0.,0.)",
	0,"null",
	4,"MASH",
	1,"false",
	1,"false",
	0,"level0",
	0,"null",
	0,"Movement"
]
#func _ready():ActionVariableType=Mashlogue.ActionVariableType
func updateValues():
	#resizes
	if Actions.size()!=ActionValues.size():ActionValues.resize(Actions.size())
	#makes the value valid for what we want
	
	#makes sure all actions have the right corresponding input type
	for _action in Actions.size():
		var act=Actions[_action]
		if ActionVariableType[act*2]==typeof(ActionValues[_action]):continue
		ActionValues[_action]=getActionVar(act)
		

#triggers the actions for itself
func trigger():
	for action in Actions.size():call(Mashlogue.Actions.keys()[Actions[action]],ActionValues[action])


#returns variable type from string reference
#very useful for the purpose I gave it
func getActionVar(_actionId):
	var inp=ActionVariableType[_actionId*2+1]
	var out=str_to_var(inp)
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

func toggleplayerlock(_null):
	if !_null&&!Word.player.locked:Word.player.canVacuum=true
	Word.player.locked=_null
#useless and pointless
func showLogic(_null):pass;#Pausemenu.get_node("logic").visible=true

func toggleEditor(_null):
	Word.canChange=_null
func changeScene(_path):
	Transitions.transitionScene("res://World/%s.tscn"%_path)

func showControls(_node):
	Pausemenu.get_node("Controls/%s"%_node).visible=true
