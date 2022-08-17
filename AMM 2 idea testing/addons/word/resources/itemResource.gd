@tool
extends Position2D
class_name itemResource
#signals for the node to emit
#mainly just used for the tutorial and events
#but is fairly helpful outside as well for debugging
signal showingName(me)
signal swappedWord(start,end)
signal changedStatus(status)
signal use_item(usedBy,action)

@export var HeldResource:Resource=itemContents.new()

@export var Status:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
var descriptiveLabel=Label.new()
var size=Vector2.ZERO
var descriptiveScript=Node2D.new()
@export var makeRigid:bool=false
#prepares basic setup for items
func _ready():
	
	#makes it a rigidbody
	
	if makeRigid&&!Engine.is_editor_hint():
		call_deferred('makeMeRigid')
		Status.append("moveable")
	sprite.texture=HeldResource.Sprites["default"]
	size=Vector2(sprite.texture.get_width(),sprite.texture.get_height())*scale
	sprite.centered=false
	if !Engine.is_editor_hint():z_index+=1
	sprite.z_index=-1
	add_child(sprite)
	add_child(descriptives)
	add_child(descriptiveLabel)
	sprite.name="Sprite2D"
	descriptiveLabel.theme=load("res://themes/basetheme.tres")
	descriptives.theme=descriptiveLabel.theme
	descriptives.position-=Vector2(2,2)
	descriptiveLabel.position.y=-16
	updateDescriptives()
	#loads the area check around itself
	var check=CollisionShape2D.new()
	var hold=StaticBody2D.new()
	hold.add_child(check)
	add_child(hold)
	add_child(descriptiveScript)
	check.shape=CircleShape2D.new()
	check.shape.radius=max(size.x,size.y)
	hold.collision_layer=4
	hold.collision_mask=4
	descriptiveLabel.visible=false
	hold.position+=size/2.
	if !makeRigid:applyScripts(Status,true)
	descriptiveScript.name="ScriptHolder"


func makeMeRigid():
	var body=RigidDynamicBody2D.new()
	get_parent().add_child(body)
	get_parent().remove_child(self);body.add_child(self)
	applyScripts(Status,true)
	body.position=position+size/2;position=-size/2;body.can_sleep=false;body.lock_rotation=true
	body.continuous_cd=RigidDynamicBody2D.CCD_MODE_CAST_SHAPE
	body.linear_damp=50
	body.freeze_mode=RigidDynamicBody2D.FREEZE_MODE_STATIC
	body.freeze=!makeRigid
#removes and loads the new descriptives
func updateDescriptives():
	sprite.texture=HeldResource.Sprites['default']
	descriptiveLabel.text=""
	for child in descriptives.get_children():child.queue_free()
	for descriptive in Status:applyDescriptive(descriptive)
	descriptiveLabel.text+=HeldResource.Name
	descriptiveLabel.size.x=0
	call_deferred("update_label")

func update_label():
	await("idle_frame")
	descriptiveLabel.position.x=-descriptiveLabel.size.x/2+size.x/2.


func removeDescriptive(id):
	var out = descriptives[id]
	descriptives.remove_at(id)
	updateDescriptives()
	return out

#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	if descriptive=="":return
	#if sprite changes with descriptive, it will show it here
	if HeldResource.has_sprite(descriptive):
		sprite.texture=HeldResource.Sprites[descriptive]
	#applies basic descriptive icons as well
	var des=HeldResource.make_descriptive_icon(descriptive)
	if des!=null:descriptives.add_child(des)
	descriptiveLabel.text+="%s "%(descriptive[0].to_upper() + descriptive.substr(1,-1))



#shows and hides the name and descriptives when you are near or away from it
func showName():
	emit_signal("showingName",self)
	descriptiveLabel.visible=true
	if !Word.hoveringObjects.has(self):
		for object in Word.hoveringObjects:object.hideName(false)
		Word.hoveringObjects.append(self)
func hideName(removed=true):
	descriptiveLabel.visible=false
	if Word.hoveringObject==self:
		Word.hoveringObject=null
	if removed:
		Word.hoveringObjects.erase(self)
		if Word.hoveringObjects.size()==0:return
		Word.hoveringObjects[Word.hoveringObjects.size()-1].showName()


#gets the name and descriptives as their phrase
func getText():
	var text=""
	for item in Status:
		text+="%s "%item
	return text+getName().replace(" "," ")
#returns its name
func getName():
	return HeldResource.Name

#modifies to match the changed descriptives
func modifyTo(_descriptives):
	_descriptives.resize(_descriptives.size()-1)
	Status=_descriptives
	updateDescriptives()
	applyScripts(Status)
	emit_signal("changedStatus",Status)

const opposites=[
	"open",
	"locked",
	"broken",
	"weak",
	"light",
	"heavy"
]

#checks if you can put in the current word
func checkWordInput(inWord):
	if(inWord=="KEY"&&!Word.wordSwap.BaseText.contains("locked")):return false
	var id=opposites.find(inWord)
	if(id==-1):return true
	var checkSide=int(id%2==0)*2-1
	return !Word.wordSwap.BaseText.contains(opposites[id+checkSide])











#checks words on the item and deals with the changes they cause on one another
func updateWordsFromOthers():
	#opens locked if there is a key
	if(Status.has("KEY")&&Status.has("locked")):
		Status.remove_at(Status.find("KEY"))
		Status[Status.find("locked")]="open"
		emit_signal("swappedWord","locked","open")
	
	#checks if it changed anything
	modifyTo(Status)

#applies the scripts it can to current object so long as it has the relevant words
func applyScripts(_descriptives,ignore=false):
	var last=descriptiveScript.get_script()
	descriptiveScript.set_script(null)
	for stat in _descriptives:
		if HeldResource.Scripts.has(stat):
			descriptiveScript.set_script(HeldResource.Scripts[stat])
	var current=descriptiveScript.get_script()
	if current==null:
		#defaults to the default script when it has no descriptives
		if HeldResource.Scripts["default"]!=null:
			descriptiveScript.set_script(HeldResource.Scripts["default"])
			current=HeldResource.Scripts["default"]
		else:
		#when you have a descriptive but none are valid
			descriptiveScript.set_script(load("res://addons/word/resources/DescriptiveScriptBase.gd"))
			current=load("res://addons/word/resources/DescriptiveScriptBase.gd")
	if Word.swapped||ignore:
		descriptiveScript._ready()
		if makeRigid:descriptiveScript.addCollision(0.5)
	
