extends Node


#the list of available faces that can be made
enum Faces {Default,Smile,Frown,MadDefault,MadSmile,MadFrown,SquintNeutral,SquintSmile,SquintFrown,GrinSquint,SquintSmallFrown}
#possible actions for eventResource
enum Actions{SetCell,ShakeCamera,MoveCamera,ResetCamera,ChangeSpeaker,toggleplayerlock,toggleEditor,changeScene,showLogic}
#stores the typeof as the value so it can be used in the event system
var ActionVariableType:Array=[
	10,"Vector3i(0,0,0)",
	1,"true",
	5,"Vector2(0.,0.)",
	0,"null",
	4,"MASH",
	1,"false",
	1,"false",
	0,"level0",
	0,"null"
]

var boxphysics=preload("res://entities/items/box/boxphysics.tres")

#variables used outside resources goes here
var _dialogueBox=null

#finishes setup
func _ready():
	_dialogueBox=load("res://addons/MASHLOG/dialoguebox/dialoguebox.tscn").instantiate()
	add_child(_dialogueBox)
	_dialogueBox.visible=false



func load_dialogue(_content:dialogueResource,_icons:iconSet):
	_dialogueBox.loadNewSet(_content,_icons)


func can_load_dialogue():return _dialogueBox.visible


func swapIcons(_newIcons):
	_dialogueBox.icon_set=_newIcons
