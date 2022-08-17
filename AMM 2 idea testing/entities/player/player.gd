extends CharacterBody2D


const SPEED = 37.5
var locked=false
@export_range(0,100) var push:int=100
var lastDir=Vector2.ZERO
var vacuum:bool=false


func _ready():
	Word.player=self
	Word.tiles=get_parent().get_node("TileMap")
	position.y+=0.6



func _physics_process(_delta):
	if locked:return
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0, SPEED)
		velocity.y = move_toward(velocity.y,0, SPEED)
	updateAnimations()
	move_and_slide()
	# after calling move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		if col.get_class()=="RigidDynamicBody2D":
			col.linear_velocity= -collision.get_normal()*Vector2(abs(direction.x),abs(direction.y))*SPEED
	doVacuum(_delta)

#uses the vacuum
func doVacuum(_delta):
	if(velocity!=Vector2.ZERO):lastDir=velocity
	$holdingItem.rotation=lerp_angle($holdingItem.rotation,$holdingItem.position.angle_to_point(get_local_mouse_position()),_delta*10)
	if !vacuum:return
	for object in $holdingItem/vaccuum.get_overlapping_bodies():
		if object.get_class()!="RigidDynamicBody2D":continue
		var moveDir=($holdingItem/vaccuum.global_position-object.global_position)
		var imp=(moveDir.normalized()*push)*(1/max(pow(48-max(moveDir.length(),1),0.125),1))
		#makes sure you dont apply force when so far it just yeets it into oblivion
		#not a real fan of bethesda suing me for sending a random pixelart item
		#into their games
		if imp.length_squared()<10240:object.apply_central_impulse(imp)


func _input(_event):
	if locked:return
	vacuum = Input.is_action_pressed("lMouse")
	$holdingItem/vaccuum/GPUParticles2D.emitting=vacuum



func _intersect_object(body):
	body.get_parent().showName()


func _left_object(body):
	body.get_parent().hideName()


#deals with animating the player
func updateAnimations():
	var chosenAnimation="idle"
	if velocity.x!=0:
		$Sprite2D.flip_h=velocity.x<0
	if velocity!=Vector2.ZERO:
		chosenAnimation="walk"
	$Sprite2D.animation=chosenAnimation
