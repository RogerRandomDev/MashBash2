extends CharacterBody2D



var freeze:bool=false
@export var max_range:int=64
@onready var root=$flyingBotPosition
@export var player:Node2D
var pushed_by_player=0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const dir={'90':Vector2(1,0),'180':Vector2(0,1),'0':Vector2(0,1)}
#allows boxes to push it
var movingBody=true
#removes basic bug for host in multiplayer
func _ready():
	player=get_parent().get_node("Player")
	if !Link.link_root.is_host:
		Pausemenu.get_node("Controls/Client").visible=true
		Pausemenu.get_node("Controls/Vacuum").visible=false
		Pausemenu.get_node("Controls/Interact").visible=false
		Pausemenu.get_node("Controls/Movement").visible=true
		Pausemenu.get_node("Controls/ClosePause").visible=true
#controlled by client side
func _physics_process(delta):
	pushed_by_player=3
	$CollisionShape2D.global_position=global_position
	#prevents host controlling them
	if (Link.link_root!=null&&Link.link_root.is_host):return

	# Get the input direction and handle the movement/deceleration.
	var direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"));
	velocity=direction*48
	if abs((position-player.position).length())>max_range:
		var pullForce=abs((position-player.position).length()-max_range)/delta * 0.1
		velocity+=(Vector2(-pullForce,0).rotated((position-player.position).angle()))
	move_and_slide()
	root.rotateTowardMotion(delta,velocity/24)
	# after calling move_and_slide()
	#pushing of objects in your way
	var vel=velocity*0.5
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		var vel2=dir[str(closestAngle(round(rad_to_deg(collision.get_angle()))))]*vel
		if col.get("movingBody"):
			if !col.freeze:
				col.velocity+=vel2
				col.move_and_slide()
			#else:position-=vel*0.25*_delta
			col.get_child(0).onMove()


func closestAngle(angle):return int(abs(angle-90)<min(abs(angle-180),abs(angle)))*90
