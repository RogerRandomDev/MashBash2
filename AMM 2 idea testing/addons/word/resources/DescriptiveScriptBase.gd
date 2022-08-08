extends Node2D
class_name itemStatus

#called when first loaded
func _ready():
	position=get_parent().size/2
	for child in get_children():child.queue_free()
