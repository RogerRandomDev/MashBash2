extends Area2D


#uses the vacuum
func doVacuum(_delta):
	get_parent().rotation=lerp_angle(get_parent().rotation,get_parent().global_position.angle_to_point(get_global_mouse_position()),_delta*10)
	for object in get_overlapping_bodies():
		if object.get_class()!="RigidDynamicBody2D":continue
		var moveDir=(global_position-object.global_position)
		var imp=(moveDir.normalized()*get_parent().get_parent().push)*(1/max(pow(48-max(moveDir.length(),1),0.125),1))
		#makes sure you dont apply force when so far it just yeets it into oblivion
		#not a real fan of bethesda suing me for sending a random pixelart item
		#into their games
		if imp.length_squared()<10240:object.apply_central_impulse(imp)
