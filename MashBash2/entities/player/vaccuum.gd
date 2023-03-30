extends Area2D

var lastSound=0
func _ready():
	await get_tree().process_frame
	$GPUParticles2D.emitting=false
var updateNextFrame=[]
#uses the vacuum
func doVacuum(_delta):
	
	for object in get_overlapping_bodies():
		if !object.get("movingBody")||object.name=="Client"||object.get("velocity")==null:continue
		var moveDir=(global_position-object.global_position)
		var imp=(moveDir.normalized()*get_parent().get_parent().push)*(1/max(pow(32-max(moveDir.length(),1),0.25),1))
		#makes sure you dont apply force when so far it just yeets it into oblivion
		#not a real fan of bethesda suing me for sending a random pixelart item
		#into their games
		
		if imp.length_squared()<10240:object.velocity=imp*2
		if object.get_child(0)&&object.get_child(0).has_method("onMove"):object.get_child(0).onMove()
	lastSound-=_delta
	if lastSound<0:
		Sounds.playSound("vacuum",-20.0);lastSound=0.1

func rotateVacuum(rotBy):
	get_parent().rotation=lerp_angle(get_parent().rotation,get_parent().global_position.angle_to_point(get_global_mouse_position()),rotBy)
	
#multiplayer functionality
@rpc("any_peer")
func update_active(active:bool=false,rot:float=0.0):
	$GPUParticles2D.emitting=active
	get_parent().rotation=rot

