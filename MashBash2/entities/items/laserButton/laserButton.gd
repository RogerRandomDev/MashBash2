extends itemStatus
class_name laserButton

signal buttonPressed()
signal buttonReleased()

var _active=false
var root=null
var sprite=null
const textures=[preload("res://entities/items/laserButton/laserbuttonon.png"),preload("res://entities/items/laserButton/laserbuttonoff.png")]

func _ready():
	super._ready()
	root=get_parent()
	toggle=get_parent().Status.has("toggle")
	sprite=root.get_node("Sprite2D")
	if get_child_count()>0:return
	var col=StaticBody2D.new()
	var shape=CollisionShape2D.new();shape.shape=RectangleShape2D.new()
	shape.shape.extents=Vector2(1,3);col.position.x+=3.5
	col.add_child(shape);add_child(col)
	var mcol=StaticBody2D.new();var s=CollisionShape2D.new()
	mcol.add_child(s);s.shape=RectangleShape2D.new();s.shape.extents=Vector2(2,4)
	add_child(mcol);mcol.position.x+=3
	col.add_to_group("receiver");col.collision_layer=16
	connect("buttonPressed",updateMode)
	connect("buttonReleased",updateMode)
var toggle=false
var justPressed=false
var lastMode=false
func toggleActive(isPressed):
	#if you have problems, this is why
	if(root.Status.has("disabled")):
		isPressed=false
		justPressed=false
		lastMode=false
	if lastMode==isPressed:return
	#pressed logic

	if toggle&&!justPressed:_active=!_active
	if !toggle:_active=isPressed
	if !isPressed&&!toggle&&!justPressed:_active=false
	
	if _active&&!justPressed:emit_signal('buttonPressed')
	if lastMode!=isPressed&&!_active:emit_signal('buttonReleased')
	justPressed=isPressed;lastMode=isPressed


func updateMode():sprite.texture=textures[int(!_active)]
