extends itemStatus
class_name itemShooter
var beam=Line2D.new()
var beamLine=PhysicsRayQueryParameters2D.new()
var t=0;
var active:bool=true
var sprite=Sprite2D.new()
var col=StaticBody2D.new()
var lineCol=Position2D.new()
func _ready():
	if get_child_count()==0:prepBeam()
	updateBeam()
	add_child(sprite);add_child(col);add_child(lineCol)
	var shape=CollisionShape2D.new();lineCol.global_position=Vector2.ZERO
	col.add_child(shape)
	shape.shape=RectangleShape2D.new()
	shape.shape.extents=Vector2(2,4);shape.position.x=2
	sprite.texture=load("res://entities/items/laserShooter/laserShooter.png")
	sprite.centered=false
	sprite.offset.y=-4;sprite.z_index+=1




func _physics_process(_delta):
	if !active:return;
	updateBeam()



#deals with the laser line
func updateBeam():
	var lastBeam=beam.points
	var _trans=global_position;var hitWall=false;var _transNormal=Vector2(1,0)
	beam.points=PackedVector2Array();var bouncedAngle=0
	if !active:return
	var loopCount=0
	beam.add_point(global_position)
	while !hitWall&&_transNormal!=Vector2.ZERO&&loopCount<15:
		beamLine.from=_trans;loopCount+=1
		beamLine.to=_trans+(Vector2(2048,0).rotated(bouncedAngle))
		
		var check=get_world_2d().direct_space_state.intersect_ray(beamLine)
		
		if check:
			beam.add_point(check.position);hitWall=true
			if check.collider.is_in_group("mirror")&&check.collider.get_class()!="TileMap":
				hitWall=false
				_trans=check.position-check.normal*0.1;_transNormal= check.normal
		else:
			hitWall=true;beam.add_point(beamLine.to)
		
		bouncedAngle=getbouncedBeam(_trans,_transNormal).get_rotation()
	if lastBeam!=beam.points:buildLaserCollision()

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
	beamLine.collision_mask=16
	
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
			var col=StaticBody2D.new()
			line=CollisionShape2D.new();line.shape=SegmentShape2D.new()
			col.add_child(line)
			lineCol.add_child(col);col.collision_layer=32
		else:line=lineChild[point].get_child(0)
		line.shape.a=beam.points[point]
		line.shape.b=beam.points[point+1]
	while lineChild.size()>beam.points.size()-1:
		lineChild[lineChild.size()-1].queue_free()
		lineChild.resize(lineChild.size()-1)
