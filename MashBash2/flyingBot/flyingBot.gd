extends Node2D
var player=null
func _ready():
	player=Word.player
	$flyingBot/face.add_to_group("flyingBot");
	$AnimationPlayer.play("hover")




func _physics_process(delta):
	position+=(player.global_position-global_position-
	Vector2(12*(int(!player.get_node("Sprite2D").flip_h)*2-1),4)
	)*delta
