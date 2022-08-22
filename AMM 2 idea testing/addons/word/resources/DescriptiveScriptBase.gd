extends Node2D
class_name itemStatus
var justSwap=true
#called when first loaded
func _ready():
	position=get_parent().size/2
	
#empties added objects
func emptyScript():
	for child in get_children():child.queue_free()
	if get_parent().makeRigid:for child in get_parent().get_parent().get_children():if child.get_class()=="CollisionShape2D":child.queue_free()


#builds collision for shape
func addCollision(scaled:float=1.0,ignore=true):
	var collision=StaticBody2D.new()
	var shape=CollisionShape2D.new()
	shape.shape=RectangleShape2D.new()
	shape.shape.extents=get_parent().size*scaled
	if !get_parent().makeRigid||ignore:
		collision.add_child(shape)
		add_child(collision)
	else:collision=shape
	pushPlayer()
	return collision
#builds an areacheck
func addArea(scaled:float=1.0,circle:bool=false):
	var collision=Area2D.new()
	var shape=CollisionShape2D.new()
	if !circle:
		shape.shape=RectangleShape2D.new()
		shape.shape.extents=get_parent().size*scaled
	else:
		shape.shape=CircleShape2D.new()
		shape.shape.radius=max(get_parent().size.x,get_parent().size.y)*scaled
	collision.add_child(shape)
	
	add_child(collision)
	return collision


#moves player out of the way when the collision is made
#keeps you from getting stuck
func pushPlayer():
	
	if (Word.player.global_position-global_position).length_squared() >=25:return
	var check=PhysicsShapeQueryParameters2D.new()
	check.shape=RectangleShape2D.new()
	check.shape.extents=Vector2(3,5)
	check.collision_mask=1
	var space = get_world_2d().direct_space_state
	var myCell=Word.tiles.world_to_map(global_position)
	#checks surroundings first
	#prioritizes top left
	for x in 3:for y in 3:
		if((abs(x-1)!=0&&abs(y-1)!=0)):continue
		
		check.transform=Transform2D(0.,Word.tiles.map_to_world(myCell+Vector2i(x-1,y-1))-Vector2(2,2))
		#moves to first available spot it can
		if space.intersect_shape(check).size()<=1:
			Word.player.global_position=check.transform.origin
			break
	
