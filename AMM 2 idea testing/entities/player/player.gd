extends CharacterBody2D


const SPEED = 37.5
var locked=false
@export_range(0,100) var push:int=100

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
	if(velocity!=Vector2.ZERO):
		$holdingItem.look_at(velocity+$holdingItem.global_position)
	for object in $holdingItem/vaccuum.get_overlapping_bodies():
		if object.get_class()!="RigidDynamicBody2D":continue
		var moveDir=($holdingItem/vaccuum.global_position-object.global_position)
		object.apply_central_impulse((moveDir.normalized()*push)*(moveDir.length_squared()/128))




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
