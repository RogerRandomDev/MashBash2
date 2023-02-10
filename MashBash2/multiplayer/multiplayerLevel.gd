extends Node2D
class_name MultiplayerLevel
@onready var linkCord=$characterLink
@export var markerTexture:Texture
# Called when the node enters the scene tree for the first time.
func _ready():
	if Link.link_root.is_host:
		Link.link_root.local=$Player
		Link.link_root.target=$Client
	else:
		Link.link_root.local=$Client
		Link.link_root.target=$Player
		var camera=$Player/Camera2D
		#swaps camera from player to the flying bot if that is the one being controlled
		$Player.remove_child(camera)
		$Client/flyingBotPosition.add_child(camera)
	Word.storedWords.append("open")
	Link.link_root.enteredGame()

func _process(delta):
	if Link.link_root==null:return
	linkCord.set_point_position(0,Link.link_root.local.global_position)
	linkCord.set_point_position(1,Link.link_root.target.global_position)
	Link.link_root.send("update_parameter",['global_position',Link.link_root.local.global_position],Link.link_root)
	#bot force to player
	var pullForce=($Client.position-$Player.position).length()-$Client.max_range
	updateLinkCord(pullForce)


#updates link cord based on pull force to the bot towards player
func updateLinkCord(pullForce:float):
	pullForce=max(0,pullForce*0.1)+1
	(linkCord.material as ShaderMaterial).set_shader_parameter("thickness",0.3*(1/((pullForce))))

#only needed to deal with markers for client side
func _input(_event):
	#returns if not the client
	if Link.link_root==null||Link.link_root.is_host:return
	if !Input.is_action_just_pressed("lMouse"):return
	var mPos=get_global_mouse_position()
	createMarker(mPos)
	Link.link_root.send("createMarker",[mPos],self)


#handles placing markers for client to host when client attempts it
@rpc(any_peer)
func createMarker(markerPos:Vector2):
	var marker=Sprite2D.new()
	marker.texture=markerTexture
	add_child(marker)
	marker.global_position=markerPos
	await get_tree().create_timer(5.0).timeout
	marker.queue_free()
	
