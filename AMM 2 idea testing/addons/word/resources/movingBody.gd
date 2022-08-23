extends CharacterBody2D
class_name movingBody2D
var freeze=false

func _ready():motion_mode=CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(_delta):
	#locks in place
	if freeze:
		velocity=Vector2.ZERO
		return
	if get_node("ItemResource").Status.has("light"):velocity*=1.5
	velocity/=2
	move_and_slide()
	# after calling move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		if col.get_class()=="CharacterBody2D"&&col.name!="Player":
			if !col.freeze:
				var vel=collision.get_normal()*0.5
				col.position-=vel
				position+=vel
				col.velocity+=vel
			else:position+=collision.get_normal()

