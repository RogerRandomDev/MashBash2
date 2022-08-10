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

#checks if it has a valid sprite for the given descriptive
func has_sprite(descriptive):
	return Sprites.has(descriptive)

#makes icon for descriptives
func make_descriptive_icon(descriptive):
	var icon = TextureRect.new()
	if !File.file_exists("res://addons/word/descriptiveIcons/%s.png"%descriptive):return null
	icon.texture=load("res://addons/word/descriptiveIcons/%s.png"%descriptive)
	icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.ignore_texture_size=true
	icon.size=Vector2(4,4)
	icon.custom_minimum_size=Vector2(4,4)
	return icon
