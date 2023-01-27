extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var freeze:bool=false
@onready var root=$flyingBotPosition
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const dir={'90':Vector2(1,0),'180':Vector2(0,1),'0':Vector2(0,1)}

#removes basic bug for host in multiplayer

#controlled by client side
func _physics_process(delta):
	$CollisionShape2D.global_position=global_position
	#prevents host controlling them
	if Link.link_root.is_host:return

	# Get the input direction and handle the movement/deceleration.
	var direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"));
	velocity=direction*64

	move_and_slide()
	root.rotateTowardMotion(delta,velocity/32)
	# after calling move_and_slide()
	#pushing of objects in your way
	var vel=velocity*0.5
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		var vel2=dir[str(closestAngle(round(rad_to_deg(collision.get_angle()))))]*vel
		if col.get_class()=="CharacterBody2D":
			if !col.freeze:
				col.velocity+=vel2
			#else:position-=vel*0.25*_delta
			col.get_child(0).onMove()

func closestAngle(angle):return int(abs(angle-90)<min(abs(angle-180),abs(angle)))*90
