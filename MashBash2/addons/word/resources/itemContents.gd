@tool
extends Resource
class_name itemContents
#sets up conditionals and states that an object can have on itself
@export var Name:String
@export var Sprites:Dictionary:
	set(value):
		if value.size()>0&&!value.values()[value.size()-1] is CompressedTexture2D:
			value[value.keys()[value.size()-1]]=Texture2D.new()
		Sprites=value
	get:return Sprites
@export var Scripts:Dictionary={"default":null}
@export var logicOff:String="locked"
@export var logicOn:String="open"
#checks if it has a valid sprite for the given descriptive
func has_sprite(descriptive):
	return Sprites.has(descriptive)

#makes icon for descriptives
func make_descriptive_icon(descriptive):
	var icon = Sprite2D.new()
	if Word.alldescriptives.has(descriptive):
		var tex= load("res://addons/word/descriptiveIcons/%s.png"%descriptive)
		icon.texture=tex
		icon.scale=Vector2(0.5,0.5)
		return icon
	return null
