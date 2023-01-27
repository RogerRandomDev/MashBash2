extends Node2D
var player=null
@export var is_multiplayer:bool=false
func _ready():
	player=Word.player
	$flyingBot/face.add_to_group("flyingBot");
	$AnimationPlayer.play("hover")


func rotateTowardMotion(delta,moveDir):

	var angle=moveDir.distance_to(Vector2(0,0))*0.005*PI*sign(moveDir.x)
	if angle<-PI/4:angle=-PI/4
	if angle>PI/4:angle=PI/4
	rotation=lerp_angle(rotation,angle,delta*10)
	#position+=moveDir*delta*3

func _physics_process(delta):
	#handles when multiplayer is active, the client controls the bot instead
	if is_multiplayer:
		userControl(delta);return
	#default controls
	var moveDir=(player.global_position-global_position-
	Vector2(12*(int(!player.get_node("Sprite2D").flip_h)*2-1),4)
	)
	position+=moveDir*delta
	

func getMovement():
	return Vector2(int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left")),int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up")))

func userControl(delta):
#	var moveDir=getMovement()
#	position+=moveDir*delta*32
#	rotateTowardMotion(delta,moveDir*4)
	return


var velocity=Vector2.ZERO
@rpc(any_peer)
func updateAnimations():pass
