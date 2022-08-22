extends itemStatus
var root=null
var toggle:bool=false
var check=Area2D.new()
var justPressed=false;var pressed=false
var lastMode=false
signal buttonPressed()
signal buttonReleased()
func _ready():
	if Engine.is_editor_hint():return
	root=get_parent()
	var groups=root.get_groups()
	toggle=groups.has("toggle");
	
	
	if get_child_count()!=0:
		for body in check.get_overlapping_bodies():checkEntered(body)
		return
	var area=CollisionShape2D.new();area.shape=RectangleShape2D.new();area.shape.extents=Vector2(4,2)
	area.position+=Vector2(4,1);check.collision_mask=8
	check.add_child(area);add_child(check);
	check.connect("body_entered",checkEntered)
	check.connect("body_exited",checkExited)
	connect("buttonPressed",onPress)
	connect("buttonReleased",onRelease)
	#button collision area
	var col=CollisionShape2D.new();var hold=StaticBody2D.new()
	hold.add_child(col);col.shape=RectangleShape2D.new();col.shape.extents=Vector2(4,2)
	hold.position+=Vector2(4,0);add_child(hold)

func checkExited(body):
	var checked=checkValidBody(body,false)
	if checked!=null:triggerPressed(!checked)
func checkEntered(body):
	var checked=checkValidBody(body)
	if checked!=null:triggerPressed(checked)
#makes sure body is valid and is pressing it
func checkValidBody(body,entering=true):
	var checked=true
	if body.get_class()=="TileMap":return null
	var itemStat=body.get_node_or_null("ItemResource")
	if itemStat==null:return checked
	if itemStat.get_class()=="Position2D"&&(
itemStat.Status.has("light")&&!root.Status.has("light"))||(
!itemStat.Status.has("heavy")&&root.Status.has("heavy")):checked=!entering
	return checked
func forceUpdate():for body in check.get_overlapping_bodies():checkEntered(body)


func triggerPressed(isPressed):
	if toggle&&!justPressed:pressed=!pressed
	if !toggle:pressed=isPressed
	if !isPressed&&!toggle&&!justPressed:pressed=false
	
	if pressed&&!justPressed:emit_signal('buttonPressed')
	if lastMode!=isPressed&&!pressed:emit_signal('buttonReleased')
	justPressed=isPressed
	lastMode=isPressed


func onPress():
	root.sprite.texture=load("res://entities/items/button/pressed.png")

func onRelease():
	root.sprite.texture=load("res://entities/items/button/released.png")




