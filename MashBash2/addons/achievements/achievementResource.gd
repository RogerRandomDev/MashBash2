@tool
extends Resource
class_name achievementItem

@export var name:String=""
@export var texture:Texture2D
@export_multiline var description:String=""
@export var pointValue:int=50



func build():
	var base=Control.new()
	var item=Panel.new();item.size=Vector2(36,48)
	var img=TextureRect.new();item.add_child(img)
	img.ignore_texture_size=true;img.size=Vector2(32,32);img.texture=texture
	img.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;img.position=Vector2(2,2)
	var nm=Label.new();item.add_child(nm);nm.text=name;nm.position=Vector2(1,34);nm.scale=Vector2(0.333,0.333);
	nm.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;nm.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	nm.size=Vector2(84,38);base.add_child(item)
	return base
