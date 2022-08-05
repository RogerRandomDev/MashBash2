extends CharacterBody2D


const SPEED = 300.0




func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0, SPEED)
		velocity.y = move_toward(velocity.y,0, SPEED)
	
	move_and_slide()






func _intersect_object(body):
	body.get_parent().showName()


func _left_object(body):
	body.get_parent().hideName()
