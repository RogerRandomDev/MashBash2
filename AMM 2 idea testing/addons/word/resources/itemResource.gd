@tool
extends Position2D
class_name itemResource

#sets up conditionals and states that an object can have on itself
@export var Name:String
@export var Sprites:Dictionary:
	set(value):
		if value.size()>0&&!value.values()[value.size()-1] is CompressedTexture2D:
			value[value.keys()[value.size()-1]]=Texture2D.new()
		Sprites=value
	get:return Sprites
@export var Status:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
#prepares basic setup for items
func _ready():
	sprite.texture=Sprites["default"]
	sprite.centered=false
	add_child(sprite)
	add_child(descriptives)



#removes and loads the new descriptives
func updateDescriptives():
	for child in descriptives.get_children():child.queue_free()
	for descriptive in Status:applyDescriptive(descriptive)




#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	pass
