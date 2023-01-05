extends Marker2D
class_name nextLevel
@export var size:Vector2
@export var changeTo:String
var checkArea=PhysicsShapeQueryParameters2D.new();var collided=false
func _ready():
	position+=size/2
	checkArea.shape=RectangleShape2D.new()
	checkArea.shape.extents=size/2;checkArea.transform=transform


func _physics_process(delta):
	if collided:return
	for checked in get_world_2d().direct_space_state.intersect_shape(checkArea):
		if checked.collider.name=="Player":collide()



func collide():
	collided=true;get_tree().change_scene("res://World/%s.tscn"%changeTo)
