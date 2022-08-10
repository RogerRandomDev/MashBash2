@tool
extends Position2D
class_name itemResource


@export var HeldResource:Resource=itemContents.new()

@export var Status:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
var descriptiveLabel=Label.new()
var size=Vector2.ZERO
var descriptiveScript=Node2D.new()


#prepares basic setup for items
func _ready():
	z_index+=1
	descriptiveLabel.theme=load("res://themes/worldtheme.tres")
	
	sprite.texture=HeldResource.Sprites["default"]
	size=Vector2(sprite.texture.get_width(),sprite.texture.get_height())
	sprite.centered=false
	sprite.z_index=-1
	sprite.add_child(descriptives)
	add_child(sprite)
	descriptiveLabel.visible=false
	add_child(descriptiveLabel)
	descriptiveLabel.position.y=-8
	descriptiveLabel.scale*=0.5
	updateDescriptives()
	#loads the area check around itself
	var check=CollisionShape2D.new()
	var hold=StaticBody2D.new()
	
	check.shape=CircleShape2D.new()
	check.shape.radius=max(size.x,size.y)
	hold.collision_layer=4
	hold.collision_mask=4
	hold.position+=size/2.
	hold.add_child(check)
	add_child(hold)
	add_child(descriptiveScript)
	applyScripts(Status)



#removes and loads the new descriptives
func updateDescriptives():
	descriptiveLabel.text=""
	sprite.texture=HeldResource.Sprites["default"]
	for child in descriptives.get_children():child.queue_free()
	for descriptive in Status:applyDescriptive(descriptive)
	descriptiveLabel.text+=HeldResource.Name
	descriptiveLabel.size.x=0
	call_deferred("update_label")

func update_label():
	await("idle_frame")
	descriptiveLabel.position.x=-(descriptiveLabel.size.x*descriptiveLabel.scale.x)/2+size.x/2.


func removeDescriptive(id):
	var out = descriptives[id]
	descriptives.remove_at(id)
	updateDescriptives()
	return out

#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	#if sprite changes with descriptive, it will show it here
	if HeldResource.has_sprite(descriptive):
		sprite.texture=HeldResource.Sprites[descriptive]
	#applies basic descriptive icons as well
	descriptives.add_child(HeldResource.make_descriptive_icon(descriptive))
	descriptiveLabel.text+="%s "%descriptive



#shows and hides the name and descriptives when you are near or away from it
func showName():
	descriptiveLabel.visible=true
	Word.hoveringObject=self
func hideName():
	descriptiveLabel.visible=false
	if Word.hoveringObject==self:Word.hoveringObject=null


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
	applyScripts(_descriptives)



#applies the scripts it can to current object so long as it has the relevant words
func applyScripts(_descriptives):
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
	if current!=null&&current!=last:descriptiveScript._ready()
	
