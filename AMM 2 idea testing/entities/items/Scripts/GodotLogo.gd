extends itemStatus



func _ready():
	super._ready()
	#builds collision
	var collision=StaticBody2D.new()
	var shape=CollisionShape2D.new()
	collision.add_child(shape)
	add_child(collision)
	shape.shape=RectangleShape2D.new()
	shape.shape.extents=get_parent().size/2
	
	
