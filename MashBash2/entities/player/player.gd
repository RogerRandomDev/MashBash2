extends CharacterBody2D


const SPEED = 37.5
var locked=false
@export_range(0,100) var push:int=100
var lastDir=Vector2.ZERO
var vacuum:bool=false
@export var canVacuum:bool=false
const freeze=false
func _ready():
	add_to_group("player")
	Word.player=self
	Word.tiles=get_parent().get_node("TileMap")
	position.y+=0.6
#keeps pushing linear and prevents janky physics
const dir={'90':Vector2(1,0),'180':Vector2(0,1),'0':Vector2(0,1)}
#the janky wheels of my integration go square and square
#all through the town
#but i altered the laws of the universe so squares roll now
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
	var vel=velocity*0.5
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		var vel2=dir[str(closestAngle(round(rad_to_deg(collision.get_angle()))))]*vel
		if col.get_class()=="CharacterBody2D":
			if !col.freeze:
				col.velocity+=vel2
			#else:position-=vel*0.25*_delta
			
	
	if vacuum:
		$holdingItem/vaccuum.rotateVacuum(_delta*10.0)
		$holdingItem/vaccuum.doVacuum(_delta)




func _input(_event):
	if locked:return
	
	if canVacuum:
		var doVacuum=Input.is_action_pressed("lMouse")
		if vacuum!=doVacuum:
			$holdingItem/vaccuum.rotateVacuum(1.0)
		set_deferred('vacuum',doVacuum)
		$holdingItem/vaccuum/GPUParticles2D.emitting=doVacuum


#gets angle closest to current
func closestAngle(angle):return int(abs(angle-90)<min(abs(angle-180),abs(angle)))*90


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
