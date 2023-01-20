extends Node2D
var player=null
func _ready():
	player=Word.player
	$flyingBot/face.add_to_group("flyingBot");
	$AnimationPlayer.play("hover")


func rotateTowardMotion(delta,moveDir):

	var angle=moveDir.distance_to(Vector2(0,0))*0.005*PI*sign(moveDir.x)
	if angle<-PI/4:angle=-PI/4
	if angle>PI/4:angle=PI/4
	rotation=lerp_angle(rotation,angle,delta*10)
	position+=moveDir*delta*3

func _physics_process(delta):
	var moveDir=(player.global_position-global_position-
	Vector2(12*(int(!player.get_node("Sprite2D").flip_h)*2-1),4)
	)
	position+=moveDir*delta
	rotateTowardMotion(delta,moveDir)
