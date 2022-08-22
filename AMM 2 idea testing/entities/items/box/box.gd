extends itemStatus

var root=null
#preps crate
func _ready():
	root=get_parent().get_parent()
	root.freeze=false
	super._ready()
	emptyScript()
	checkButtons()
	if get_parent().Status.has("heavy"):root.freeze=true


func checkButtons():
	var check=PhysicsShapeQueryParameters2D.new()
	check.shape=RectangleShape2D.new();check.collide_with_areas=true
	check.shape.extents=Vector2(9,9);check.transform=Transform2D(0,global_position+Vector2(4,4))
	var objects=get_world_2d().direct_space_state.intersect_shape(check)
	for shape in objects:
		shape.collider=shape.collider.get_parent()
		if shape.collider.name!="ScriptHolder":continue
		if shape.collider.get("lastMode")!=null:shape.collider.forceUpdate()
