@tool
extends Marker2D
class_name itemResource
#signals for the node to emit
#mainly just used for the tutorial and events
#but is fairly helpful outside as well for debugging
signal showingName(me)
signal swappedWord(start,end)
signal changedStatus(status)
signal use_item(usedBy,action)

@export var HeldResource=itemContents.new()

@export var Status:PackedStringArray
@export var HiddenStatus:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
var descriptiveLabel=Label.new()
var size=Vector2.ZERO
var descriptiveScript=Node2D.new()

@export var makeRigid:bool=false
#prepares basic setup for items
func _ready():
	Status=Status.duplicate()
	add_to_group("item")
	#makes it a rigidbody
	if !Engine.is_editor_hint():
		call_deferred('makeMeRigid')
	sprite.texture=HeldResource.Sprites["default"]
	size=Vector2(sprite.texture.get_width(),sprite.texture.get_height())*scale
	sprite.centered=false
	descriptiveLabel.self_modulate=Color("d8d8d8")
	z_index=2
	sprite.z_index=-3
	descriptiveLabel.rotation=-rotation
	descriptives.rotation=-rotation
	add_child(sprite)
	
	add_child(descriptives)
	add_child(descriptiveLabel)
	sprite.name="Sprite2D"
	descriptiveLabel.theme=load("res://themes/basetheme.tres")
	descriptives.theme=descriptiveLabel.theme
	descriptives.position=Vector2(4,4)
	descriptives.position-=(size+Vector2(4,4)).rotated(-rotation)*0.5
	updateDescriptives.call_deferred()
	if !Engine.is_editor_hint():
		#loads the area check around itself
		var check=CollisionShape2D.new()
		var hold=StaticBody2D.new()
		hold.add_child(check)
		add_child(hold)
		add_child(descriptiveScript)
		check.shape=RectangleShape2D.new()
		check.shape.extents=Vector2(size.x,size.y)/1.75
		hold.collision_layer=4
		hold.collision_mask=4
		hold.position+=size/2.
	descriptiveLabel.visible=false
	descriptiveScript.name="ScriptHolder"
	if !Engine.is_editor_hint():Status.append_array(HiddenStatus)


func makeMeRigid():
	var body=movingBody2D.new()
	body.collision_layer=25
	body.collision_mask=9
	if makeRigid:body.rotation=rotation
	get_parent().add_child(body)
	get_parent().remove_child(self);body.add_child(self)
	body.position=position+size/2;position=-size/2;
	body.freeze=!makeRigid
	if makeRigid:rotation=0
	body.name=name
	self.name="ItemResource"
	applyScripts(Status,true)

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
	descriptiveLabel.size.y=0
	descriptiveLabel.position=Vector2(4,4);
	descriptiveLabel.position-=(descriptiveLabel.size/2.+Vector2(0,8)).rotated(-rotation)


func removeDescriptive(id):
	var out = descriptives[id]
	descriptives.remove_at(id)
	updateDescriptives()
	return out

#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	if descriptive==""||Engine.is_editor_hint():return
	#if sprite changes with descriptive, it will show it here
	if HeldResource.has_sprite(descriptive):
		sprite.texture=HeldResource.Sprites[descriptive]
	#applies basic descriptive icons as well
	var des=HeldResource.make_descriptive_icon(descriptive)
	if des!=null:
		descriptives.add_child(des)
		des.z_index=4
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
	"heavy",
	"active",
	"disabled"
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
	var new = null
	
	for stat in _descriptives:
		if HeldResource.Scripts.has(stat):new = HeldResource.Scripts[stat]
	if new==null:
		#defaults to the default script when it has no descriptives
		if HeldResource.Scripts["default"]!=null:
			descriptiveScript.set_script(HeldResource.Scripts["default"])
			new=HeldResource.Scripts["default"]
		else:
		#when you have a descriptive but none are valid
			descriptiveScript.set_script(load("res://addons/word/resources/DescriptiveScriptBase.gd"))
			new=load("res://addons/word/resources/DescriptiveScriptBase.gd")
	if Word.swapped||ignore:
		descriptiveScript.set_script(new)
		descriptiveScript._ready()
		descriptiveScript.logicDescriptives=[HeldResource.logicOff,HeldResource.logicOn]
		if makeRigid:
			var col=descriptiveScript.addCollision(0.49,false)
			get_parent().add_child(col)
	if descriptiveScript.has_method("checkButtons"):
		descriptiveScript.checkButtons()
	
func canPull():
	if !descriptiveScript.has_method("canPull"):return true
	return descriptiveScript.canPull()
