extends Area2D

@export var nextlvl:String="null"
func _ready():
	add_to_group("endLevel");
func _on_area_2d_body_entered(body):
	if(nextlvl.contains("title")):Mashlogue._dialogueBox.forceStop()
	if(body.name=="Player"):Transitions.transitionScene(nextlvl)
