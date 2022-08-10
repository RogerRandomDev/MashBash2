extends CharacterBody2D


const SPEED = 37.5

func _ready():
	Word.player=self
	Word.tiles=get_parent().get_node("TileMap")



func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0, SPEED)
		velocity.y = move_toward(velocity.y,0, SPEED)
	updateAnimations()
	move_and_slide()






func _intersect_object(body):
	body.get_parent().showName()


func _left_object(body):
	body.get_parent().hideName()


#deals with animating the player
func updateAnimations():
	var chosenAnimation="idle"
	if velocity.x!=0:
		$Sprite2D.flip_h=velocity.x<0
	if velocity!=Vector2.ZERO:chosenAnimation="walk"
	$Sprite2D.animation=chosenAnimation
