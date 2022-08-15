extends itemStatus

var linkTo=""
var linked=null
var arrow=null
var triggerNow=true
func _ready():
	super._ready()
	emptyScript()
	var area=addArea(0.25,true)
	area.connect("body_entered",checkTeleport)
	#links to the connected teleporter
	for group in get_parent().get_groups():
		group=String(group)
		if group.contains("Teleporter"):
			var let="AB"[int(group.contains("A"))]
			linkTo=group.left(group.length()-1)+let
			break
	linked=get_tree().get_nodes_in_group(linkTo)[0]
	makeArrow()
	arrow.look_at(linked.position);arrow.rotation+=PI/2




#makes arrow to point at the linked teleporter
func makeArrow():
	arrow=Sprite2D.new();arrow.scale*=0.5
	arrow.texture=load("res://entities/items/teleporter/arrow.png");add_child(arrow)
	var mat=ShaderMaterial.new()
	mat.shader=load("res://entities/items/teleporter/teleporterArrow.gdshader")
	arrow.material=mat
	

#checks if the new object to enter is the player, and if so, it teleports it
func checkTeleport(body):

	if body.name=="Player":
		#checks if you were just teleported to it
		if !triggerNow:
			triggerNow=true;return
		linked.get_node("ScriptHolder").triggerNow=false
		body.position+=linked.position-get_parent().position
