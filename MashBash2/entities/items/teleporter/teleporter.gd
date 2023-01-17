extends itemStatus

var linkTo=""
var linked=null
var arrow=null
var triggerNow=true
var teleporting=null
var area=null
func _ready():
	super._ready()
	
	emptyScript()
	triggerNow=false
	if (Word.player.global_position-global_position).length_squared()>16:triggerNow=true
	area=addArea(0.25,true);
	area.connect("area_entered",checkTeleport)
	area.connect("body_entered",checkTeleport)
	area.position.y-=4
	#links to the connected teleporter
	for _group in get_parent().get_groups():
		var group=String(_group)
		if group.contains("teleporter"):
			var let="AB"[int(group.contains("A"))]
			linkTo=group.left(group.length()-1)+let
			break
	linked=get_tree().get_nodes_in_group(linkTo)[0]
	makeArrow()
	
	if !Engine.is_editor_hint():
		if !get_parent().Status.has("disabled")&&!get_parent().Status.has("inactive")&&!get_parent().Status.has("active"):get_parent().Status.append("active")
		if get_parent().Status.has("inactive"):get_parent().Status.remove_at(get_parent().Status.find("inactive"))
		get_parent().updateDescriptives()
	arrow.look_at(linked.global_position+Vector2(4,4));arrow.rotation+=PI/2
	




#makes arrow to point at the linked teleporter
func makeArrow():
	arrow=Sprite2D.new();arrow.scale*=0.5
	arrow.texture=load("res://entities/items/teleporter/arrow.png");add_child(arrow)
	var mat=ShaderMaterial.new()
	mat.shader=load("res://entities/items/teleporter/teleporterArrow.gdshader")
	arrow.material=mat
	

#checks if the new object to enter is the player, and if so, it teleports it
func checkTeleport(body):
	if !get_parent().Status.has("active")||!linked.Status.has("active"):return
	if get_parent().Status.has("broken")||linked.Status.has("broken"):return
	if get_parent().Status.has("disabled")||linked.Status.has("disabled"):return
	if teleporting!=null:return
	if body.name=="playerchest":
		#checks if you were just teleported to it
		if !triggerNow:
			triggerNow=true;return
		animateTeleport(body.get_parent())
	else:if body.get_parent().name!="holdingItem"&&body.name!="Player":
		#checks if you were just teleported to it
		if !triggerNow:
			triggerNow=true;return
		animateTeleport(body)

#the teleporter animation
#using an animation player would honestly be nicer, but a pain still
#since this is loaded and not able to see the player in an absolute path at all times
func animateTeleport(body):
	if body.get_class()=="TileMap":return
	#prepares the animations
	var tween:Tween=create_tween()
	
	linked.get_node("ScriptHolder").triggerNow=false
	teleporting=body
	Sounds.playSound("teleport",-18)
	if body.name=="Player":body.locked=true
	else:togglebodyPhysics(false)
	body.position=global_position-Vector2(0,2.4*int(body.name=="Player"))
	#hides player
	tween.tween_method(tweenColor,0.,1.,0.5)
	tween.tween_interval(0.25)
	tween.tween_callback(teleportobject)
	#tweens camera back to player after locking to previous teleporter
	if body.name=="Player":tween.tween_property(body.get_node("Camera2D"),"position",Vector2.ZERO,0.25)
	else:tween.tween_interval(0.25)
	#returns player
	
	tween.tween_interval(0.25);
	tween.tween_callback(func():Sounds.playSound("teleport",-18))
	tween.tween_method(tweenColor,1.,0.,0.5)
	
	if body.name=="Player":tween.tween_property(body,"locked",false,0.0)
	else:tween.tween_callback(togglebodyPhysics)
	
	tween.tween_interval(0.25);tween.tween_callback(finishTeleport)


#finishes the teleport
func finishTeleport():
	get_parent().emit_signal("use_item",teleporting,"teleporter")
	updateStatus()
	teleporting=null
	for object in area.get_overlapping_bodies():
		if object.name=="Player":checkTeleport(object.get_node("playerchest"))
		else:checkTeleport(object)
	

#toggles rigidbody physics
func togglebodyPhysics(do=true):teleporting.set_deferred('freeze',!do)

#tweens the player color when teleporting
func tweenColor(col):
	var sprite=null
	if teleporting.name=="Player":sprite=teleporting.get_node("Sprite2D")
	else:sprite=teleporting.get_child(0).get_node("Sprite2D")
	sprite.modulate=Color(1.-col,1.-col/2.,1.,1.-col)

#teleports the object
func teleportobject(object=teleporting):
	#if its a player, moves the camera so it stays on the previous teleporter before moving to the new one
	if(object.name=="Player"):object.get_node("Camera2D").position+=(global_position-linked.global_position)
	object.position=linked.global_position+linked.size/2
	object.position.y=round(object.position.y)-2.4*int(object.name=="Player")

#replaces weak with broken if it is weak
func updateStatus():
	var status=get_parent().Status
	if status.has("weak"):
		get_parent().Status.remove_at(status.find("weak"))
		get_parent().Status.append("broken")
		get_parent().updateDescriptives()
