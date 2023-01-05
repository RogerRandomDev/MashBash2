extends Node2D
class_name itemStatus
var justSwap=true
var logicDescriptives=["open","locked"]
#called when first loaded
func _ready():
	position=get_parent().size/2
	
#empties added objects
func emptyScript():
	for child in get_children():child.queue_free()
	if get_parent().makeRigid:for child in get_parent().get_parent().get_children():if child.get_class()=="CollisionShape2D":child.queue_free()
func createParticles(shader,p_amount:int=16,exp:float=0.0,pre_emit:bool=false,life:float=1.0):
	var emitter=GPUParticles2D.new()
	emitter.process_material=shader;
	emitter.explosiveness=exp
	emitter.amount=p_amount
	emitter.emitting=pre_emit
	emitter.lifetime=life
	emitter.local_coords=true
	add_child(emitter)
	return emitter

#builds collision for shape
func addCollision(scaled:float=1.0,ignore=true):
	var collision=StaticBody2D.new()
	var shape=CollisionShape2D.new()
	shape.shape=RectangleShape2D.new()
	shape.shape.extents=get_parent().size*scaled
	collision.collision_layer=17
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
	var myCell=Word.tiles.local_to_map(global_position)
	#checks surroundings first
	#prioritizes top left
	for x in 3:for y in 3:
		if((abs(x-1)!=0&&abs(y-1)!=0)):continue
		
		check.transform=Transform2D(0.,Word.tiles.map_to_local(myCell+Vector2i(x-1,y-1))-Vector2(2,2))
		#moves to first available spot it can
		if space.intersect_shape(check).size()<=1:
			Word.player.global_position=check.transform.origin
			break
	
func applyLogic(active):
	if active:
		if !get_parent().Status.has(logicDescriptives[1]):get_parent().Status.append(logicDescriptives[0])
		else:get_parent().Status.remove_at(get_parent().Status.find(logicDescriptives[1]))
	else:
		#this stops you from farming one door for open and prevents you from pulling stuff i dont like
		if get_parent().Status.has(logicDescriptives[0]):get_parent().Status.remove_at(get_parent().Status.find(logicDescriptives[0]))
		else:if logicDescriptives[1]!="":get_parent().Status.append(logicDescriptives[1])
	
	get_parent().Status.append("_")
	get_parent().modifyTo(get_parent().Status)
