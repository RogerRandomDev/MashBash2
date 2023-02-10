extends CharacterBody2D
class_name movingBody2D
var freeze=false
var pushed_by_player:int=0
func _ready():motion_mode=CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(_delta):
	
	#locks in place
	if freeze:
		velocity=Vector2.ZERO
		return
#	if Link.link_root&&!Link.link_root.is_host:return
	velocity*=(0.25-_delta)
	move_and_slide()
	# after calling move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index);var col=collision.get_collider()
		if col.get("movingBody"):
			var vel=(collision.get_position()-global_position).length()
			if col.name!="Player":
				#done so that they can't push the player back, nor boxes the player is pushing
				if !col.freeze&&pushed_by_player>=col.pushed_by_player:
					col.position+=velocity.normalized()*vel*0.5*_delta*max(pushed_by_player-max(col.pushed_by_player,0),1)
					if pushed_by_player<1:
						velocity-=velocity.normalized()*vel*0.5
						position-=velocity.normalized()*vel*0.5*_delta
					col.velocity+=velocity.normalized()*vel*0.5
					col.pushed_by_player=max(col.pushed_by_player,pushed_by_player-1)
				else:position+=collision.get_normal()
			else:
				position+=collision.get_normal()*vel*_delta*5
	pushed_by_player-=1

#used to check that it is a moving body
var movingBody:bool=true
