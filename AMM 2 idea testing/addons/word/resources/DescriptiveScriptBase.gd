extends Node2D
class_name itemStatus

#called when first loaded
func _ready():
	position=get_parent().size/2
	
#empties added objects
func emptyScript():
	for child in get_children():child.queue_free()


#builds collision for shape
func addCollision(scaled:float=1.0):
	var collision=StaticBody2D.new()
	var shape=CollisionShape2D.new()
	shape.shape=RectangleShape2D.new()
	shape.shape.extents=get_parent().size*scaled
	collision.add_child(shape)
	add_child(collision)
