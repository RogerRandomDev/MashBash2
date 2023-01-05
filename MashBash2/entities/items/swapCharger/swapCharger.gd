@tool
extends Marker2D
class_name WordSwapCharger
var check=PhysicsShapeQueryParameters2D.new()
var sprite=Sprite2D.new()
var particles=GPUParticles2D.new()
var amount=Label.new()
@export var chargeAmount:int=1
func _ready():
	
	
	add_child(sprite);sprite.add_child(particles)
	sprite.add_child(amount)
	amount.text=str(chargeAmount)
	amount.theme=load("res://themes/basetheme.tres")
	amount.scale=Vector2(0.5,0.5)
	amount.size.x=16
	amount.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	amount.position-=Vector2(4,4)
	particles.process_material=load("res://World/wordswapcharger.tres")
	#looks cool, but is currently not working for idk why
	#particles.trail_enabled=true;particles.trail_length_secs=0.25;particles.trail_section_subdivisions=1;particles.trail_sections=3
	particles.amount=12
	sprite.texture=load("res://entities/flyingBot/botbody.png")
	check.shape=RectangleShape2D.new();check.shape.extents=Vector2(4,4)
	check.transform=Transform2D(rotation,position)


func _physics_process(delta):
	if Engine.is_editor_hint():return
	var col:=get_world_2d().direct_space_state.intersect_shape(check)
	for obj in col:if obj.collider.name=="Player":complete_purpose()


#it shall fulfill its purpose
#which is give you some words and die
func complete_purpose():
	Word.swapsLeft+=chargeAmount
	Word.wordSwap.addWord(chargeAmount)
	queue_free()
