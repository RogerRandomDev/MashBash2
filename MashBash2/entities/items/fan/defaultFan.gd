extends itemStatus
class_name fan
var pushBox=null
var particleEmitter=null
var root=null
var lastSound=0.0
var weak=false;var heavy=false;var active=false;var broken=false
var flatDir=Vector2.ZERO
const particles=preload("res://entities/items/fan/fanParticles.tres")
func _ready():
	super._ready()
	emptyScript()
	root=get_parent()
	var col=addCollision(0.5);
	col.get_child(0).shape.extents=Vector2(2,4);
	col.position=Vector2(-1,-1)
	weak=root.Status.has("weak")
	heavy=root.Status.has("heavy")
	active=root.Status.has("active")
	broken=root.Status.has("broken")
	addPushRange()
	flatDir.x=int(rotation==0)-int(rotation==180)
	flatDir.y=int(rotation==90)-int(rotation==270)
	particleEmitter.emitting=active&&!broken

#adds the pushing bounding box for the fan
func addPushRange():
	pushBox=addArea(1.0);
	pushBox.get_child(0).shape.extents=Vector2(16-(8*int(weak)),4)
	pushBox.position.x+=pushBox.get_child(0).shape.extents.x
	var particleLife=0.68-(0.175*int(weak))
	particleEmitter=createParticles(particles,24+8*int(heavy)-4*int(weak),0.0,false,particleLife)



func updateSelf2(delta):
	if active&&!broken:pushItems(delta)

func pushItems(_delta):
	var toPush=pushBox.get_overlapping_bodies()
	for object in toPush:
		if object.get_child_count()<=0:continue;
		var child=object.get_child(0)
		if object.name!="Player"&&(!object.get("movingBody")||object.name=="Client"||object.get("velocity")==null):continue
		if (child.get("Status")&&(child.Status.has("heavy")&&!heavy||!child.Status.has("light")&&weak)):continue
		var moveDir=(global_position-object.global_position)
		var imp=(flatDir)*(1/max(pow(48-max(moveDir.length(),1),0.125),1))
		#makes sure you dont apply force when so far it just yeets it into oblivion
		#not a real fan of bethesda suing me for sending a random pixelart item
		#into their games
		var objLast=object.velocity;
		if imp.length_squared()<10240:object.velocity= imp*16
		object.move_and_slide()
		
		if object.name=="Player":
			object.pushObjects()
		object.velocity=objLast
		if object.get_child(0)&&object.get_child(0).has_method("onMove"):object.get_child(0).onMove()
#	lastSound-=_delta
#	if lastSound<0:
#		Sounds.playSound("vacuum",-20.0);lastSound=0.1
