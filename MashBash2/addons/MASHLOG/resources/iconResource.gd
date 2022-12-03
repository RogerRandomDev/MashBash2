@tool
extends Resource
class_name iconSet

@export_color_no_alpha var modulate=Color.WHITE
@export var icon_set:Dictionary


func _init():
	if icon_set.size()!=0:return
	for key in Mashlogue.Faces.keys():
		icon_set[key]=Texture2D


func get_face(faceName):
	if icon_set[faceName]==null:return icon_set["Default"]
	return icon_set[faceName]

func get_color():return modulate
