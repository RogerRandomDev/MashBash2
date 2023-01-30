#handles shared functions between the client and host classes for networking
extends Node
class_name baseNet

#used to handle certain features to make sure client doesn't break something
var is_host=false
#boolean value for if the client and host are connected
var is_connected:bool=false

@export var target:Node=null
@export var local:Node=null
#linked node for the player object/ controlled entity
@export var link_node:Node=null


#sends data to and from server
func send(method:String='receive',data:Array=[],sendNode:Node=target):
	get_tree().get_multiplayer(get_path()).rpc(0,sendNode,method,data)
#recieves data from client/server
@rpc(any_peer)
func receive(data):
	print(data)

#prints connected when you successfully link to the server host
func OnConnectedToServer(_args=null):
	is_connected=true

#runs when server disconnects with the client and vice versa
func _on_disconnect(_args=null):
	if !is_host:Link.server_closed()

#tells server and peers that the connection is now established
@rpc(any_peer)
func establish_link(_args=null):
	is_connected=true
	send("change_level",["res://multiplayer/levels/level1M.tscn"],self)
	change_level("res://multiplayer/levels/level1M.tscn")

@rpc(any_peer)
func update_parameter(param,newValue,targeting=target):
	targeting.set(param,newValue);
@rpc(authority)
func change_level(param):
	Transitions.transitionScene(param)


func _process(_delta):
	if !is_connected||local==null:return
