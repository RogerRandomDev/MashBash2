@tool
extends Resource
class_name dialogueResource



#builds the dialogue sections and sub-parts for you
@export var dialogue:PackedStringArray:
#god i love having learned how to do this
	set(value):
		#makes sure face count is equal to the dialogue box count
		dialogue=value
		updateFormat()
	get:return dialogue
@export var dialogueFaces:Array:
	set(value):
		dialogueFaces=value
		if(value!=lastSet):
			show_chosen_faces()
		lastSet=value.duplicate(true)
		
	get:return dialogueFaces
@export var dialogueActions:Array:
	set(value):dialogueActions=value
	get:return dialogueActions
#lets the output not duplicate itself for the face list
var lastSet=null
#updates the format to make it work accurately for me most of the time
#only updates them when you collapse and re-expand though so thats a minor nusiance
func updateFormat():
	var addActions=dialogue.size()>dialogueActions.size()
	if dialogue.size()!=dialogueFaces.size():dialogueFaces.resize(dialogue.size())
	if dialogue.size()!=dialogueActions.size():dialogueActions.resize(dialogue.size())
	#makes sure you have the action resource set automatically
	if addActions:
		dialogueActions[dialogueActions.size()-1]=eventResource.new()
		dialogueFaces[dialogueFaces.size()-1]=0
	

#counts number of boxes it will use
func count_sets():return dialogue.size()

#gets current text set
func text_for(_line):
	return dialogue[_line]
#gets current face for text set
func face_for(_line):return Mashlogue.Faces.keys()[dialogueFaces[_line]]


#triggers the actions
func triggerActions(actionLine):
	if dialogueActions.size()-1<actionLine||dialogueActions[actionLine]==null:return
	dialogueActions[actionLine].trigger()
	

#shows current faces in console for you
#honestly just a quality of life for me so i dont have to remember
#the int to face conversion
func show_chosen_faces():
#	for val in dialogueFaces:print(Mashlogue.Faces.keys()[val])
	pass
