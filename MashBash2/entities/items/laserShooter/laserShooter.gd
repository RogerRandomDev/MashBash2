extends itemStatus
class_name itemShooter
var beam=Line2D.new()
var beamLine=PhysicsRayQueryParameters2D.new()
var t=0;
var active:bool=true
var sprite
var col=StaticBody2D.new()
var lineCol=Marker2D.new()
var laserParticles=GPUParticles2D.new()
var rot=0
var connected=[]
func _ready():
	
	active=get_parent().Status.has("active")
	if get_child_count()==0:
		rot=get_parent().rotation
		var shape=CollisionShape2D.new();lineCol.global_position=Vector2.ZERO
		col.add_child(shape)
		shape.shape=RectangleShape2D.new()
		shape.shape.extents=Vector2(2,4);shape.position.x=2;shape.position.y=4
		laserParticles.process_material=load("res://entities/shaderBased/LaserOnWalls.tres")
		laserParticles.amount=16
		laserParticles.lifetime=0.33
		add_child(laserParticles)
		prepBeam()
	updateBeam()
	laserParticles.emitting=active
	if col.get_parent()==null:add_child(col)
	if lineCol.get_parent()==null:add_child(lineCol)
	
	sprite=get_parent().get_node("Sprite2D")
	sprite.texture=load("res://entities/items/laserShooter/laserShooter.png")
	sprite.centered=false;sprite.z_index+=1;lineCol.top_level=true
	var timer=Timer.new();timer.wait_time=0.033;add_child(timer)
	await get_tree().process_frame
	timer.connect("timeout",physics_process);timer.start()




func physics_process():
	if !active:
		collideReceivers(false);receiverHits=[]
		for collider in lineCol.get_children():collider.queue_free();return;
	updateBeam()


#deals with the laser line
func updateBeam():
	if !is_inside_tree():return
	beam.z_index=1
	connected=[]
	var lastBeam=beam.points
	var _trans=global_position+Vector2(0,4).rotated(rot);
	var hitWall=false;var _transNormal=Vector2(1,0)
	beam.points=PackedVector2Array();var bouncedAngle=rot
	
	if !active:return
	var loopCount=0
	beam.add_point(global_position+Vector2(0,4).rotated(rot));newHits=[]
	while !hitWall&&_transNormal!=Vector2.ZERO&&loopCount<15:
		beamLine.from=_trans;loopCount+=1
		beamLine.to=_trans+(Vector2(2048,0).rotated(bouncedAngle))
		var check=get_world_2d().direct_space_state.intersect_ray(beamLine)
		
		if check:
			beam.add_point(check.position);hitWall=true
			if check.collider.is_in_group("mirror")&&check.collider.get_class()!="TileMap":
				hitWall=false
				_trans=check.position-check.normal*0.1;_transNormal= check.normal
			if check.collider.is_in_group("receiver"):
				connected.append(check.collider)
				newHits.append(check.collider)
		else:
			hitWall=true;beam.add_point(beamLine.to)
		
		bouncedAngle=getbouncedBeam(_trans,_transNormal).get_rotation()
	if lastBeam!=beam.points:buildLaserCollision()
	collideReceivers()

#i take no credit for the this part, i just made it better for my uses, beyond that
#i got it from others. thank you random coders
func getbouncedBeam(laser_coll_point,laser_coll_normal):
	var out=Transform2D(0,laser_coll_point)
	var forward = laser_coll_point+laser_coll_normal*0.1 - beamLine.from
	var reflection = -forward.reflect(laser_coll_normal)
	out.set_rotation(reflection.angle())
	return out


#builds the beam base
func prepBeam():
	beamLine.collision_mask=80
	beam.texture_mode=Line2D.LINE_TEXTURE_TILE
	beam.top_level=true;beam.width=8;beam.default_color=Color.RED
	beam.add_point(global_position)
	beam.add_point(global_position+Vector2(8,8))
	add_child(beam)
	beam.material=preload("res://entities/items/laserShooter/lasershader.tres")


#builds the collision beam for the laser
func buildLaserCollision():
	var lineChild=lineCol.get_children()
	for point in beam.points.size()-1:
		var line=null
		if lineChild.size()<=point:
			var _col=StaticBody2D.new()
			line=CollisionShape2D.new();line.shape=SegmentShape2D.new()
			_col.collision_layer=32
			_col.add_child(line)
			lineCol.add_child.call_deferred(_col);
		else:line=lineChild[point].get_child(0)
		line.shape.a=beam.points[point]
		line.shape.b=beam.points[point+1]
		laserParticles.emitting=active
		laserParticles.global_position=line.shape.b
		laserParticles.rotation=line.shape.a.angle_to(line.shape.b)
	while lineChild.size()>beam.points.size()-1:
		lineChild[lineChild.size()-1].queue_free()
		lineChild.resize(lineChild.size()-1)

var receiverHits=[]
var newHits=[]
func collideReceivers(docol=true):
	for collider in receiverHits:collider.get_parent().toggleActive(newHits.has(collider) && docol)
	receiverHits=newHits


