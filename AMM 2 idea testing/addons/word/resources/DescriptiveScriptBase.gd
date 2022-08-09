extends Node2D
class_name itemStatus

#called when first loaded
func _ready():
	position=get_parent().size/2
	
#empties added objects
func emptyScript():
	for child in get_children():child.queue_free()
