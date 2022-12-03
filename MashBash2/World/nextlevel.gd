extends Area2D

@export var nextlvl:String="null"
func _on_area_2d_body_entered(body):
	if(body.name=="Player"):Transitions.transitionScene(nextlvl)
