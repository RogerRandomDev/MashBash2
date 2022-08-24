extends itemStatus
class_name itemShooter
var beam=Line2D.new()
var beamLine=PhysicsRayQueryParameters2D.new()
var t=0;
var active:bool=true
func _ready():
	if get_child_count()==0:prepBeam()
	updateBeam()
	




func _physics_process(_delta):
	if !active:return;
	updateBeam()



#deals with the laser line
func updateBeam():
	var _trans=global_position;var hitWall=false;var _transNormal=Vector2(1,0)
	beam.points=PackedVector2Array();var bouncedAngle=0
	if !active:return
	beam.add_point(global_position)
	while !hitWall&&_transNormal!=Vector2.ZERO:
		beamLine.from=_trans
		beamLine.to=_trans+(Vector2(1024,0).rotated(bouncedAngle))
		
		var check=get_world_2d().direct_space_state.intersect_ray(beamLine)
		
		if check:
			beam.add_point(check.position);hitWall=true
			if check.collider.is_in_group("mirror")&&check.collider.get_class()!="TileMap":
				hitWall=false
				_trans=check.position-check.normal*0.1;_transNormal= check.normal
		else:
			hitWall=true;beam.add_point(beamLine.to)
		
		bouncedAngle=getbouncedBeam(_trans,_transNormal).get_rotation()


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
	beamLine.collision_mask=17
	
	beam.texture_mode=Line2D.LINE_TEXTURE_TILE
	beam.top_level=true;beam.width=8;beam.default_color=Color.RED
	beam.add_point(global_position)
	beam.add_point(global_position+Vector2(8,8))
	add_child(beam)
	beam.material=preload("res://entities/items/laserShooter/lasershader.tres")
