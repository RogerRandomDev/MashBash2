@tool
extends Sprite2D
class_name Button2D
@export var toggle:bool=false
var check=PhysicsShapeQueryParameters2D.new()
var justPressed=false
var pressed=false
var lastMode=false
signal buttonPressed()
signal buttonReleased()
#sets the texture
func _init():
	texture=load("res://entities/items/button/released.png")
	centered=false
#preps the check and other neccessities
func _ready():
	if Engine.is_editor_hint():return
	var shape=RectangleShape2D.new();shape.extents=Vector2(4,1)
	check.shape=shape;check.transform=Transform2D(rotation,global_position+shape.extents)
	connect("buttonPressed",onPress)
	connect("buttonReleased",onRelease)


func _physics_process(_delta):
	if Engine.is_editor_hint():return
	
	var collisions=get_world_2d().direct_space_state.intersect_shape(check)
	var checked=false
	for col in collisions:
		if col.collider.get_class()=="TileMap":continue
		checked=true;break
	triggerPressed(checked)
	


func triggerPressed(isPressed):
	if toggle&&!lastMode!=isPressed:pressed=!pressed
	if !toggle:pressed=isPressed
	if !isPressed&&!toggle&&!justPressed:pressed=false
	
	if pressed&&!justPressed:emit_signal('buttonPressed')
	if lastMode!=isPressed&&!pressed:emit_signal('buttonReleased')
	justPressed=isPressed
	lastMode=isPressed


func onPress():
	texture=load("res://entities/items/button/pressed.png")

func onRelease():
	texture=load("res://entities/items/button/released.png")
