extends itemStatus
class_name box
var root=null
#preps crate
func _ready():
	root=get_parent().get_parent()
	root.freeze=false
	super._ready()
	emptyScript()
	checkButtons()
	if get_parent().Status.has("heavy"):root.freeze=true
	
	#deals with making the item reflective
	for child in root.get_children():if child.get_class()=="StaticBody2D":child.queue_free()
	if get_parent().Status.has("reflective"):
		#removes from the check for lasers so it can check just the mirror below
		root.collision_layer=9
		var reflect = StaticBody2D.new()
		var shape=RectangleShape2D.new();var col=CollisionShape2D.new()
		reflect.add_child(col);col.shape=shape;shape.extents=Vector2(3,3)
		reflect.collision_layer=16;reflect.collision_mask=0;
		root.add_child(reflect);reflect.rotation=PI/4
		reflect.add_to_group("mirror")
	else:
		root.collision_layer=25


func checkButtons():
	var check=PhysicsShapeQueryParameters2D.new()
	check.shape=RectangleShape2D.new();check.collide_with_areas=true
	check.shape.extents=Vector2(9,9);check.transform=Transform2D(0,global_position+Vector2(4,4))
	var objects=get_world_2d().direct_space_state.intersect_shape(check)
	for shape in objects:
		shape.collider=shape.collider.get_parent()
		if shape.collider.name!="ScriptHolder":continue
		if shape.collider.get("lastMode")!=null&&shape.collider.has_method("forceUpdate"):shape.collider.forceUpdate()
