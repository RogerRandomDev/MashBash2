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
#handles resetting item data when player reconnects after getting disconnected
var client_already_connected:bool=false

#triggered by the levels when entered
#allows connection to nodes in the game themselves
var in_game:bool=false
var link_node_in_game:bool=false
#sends data to and from server
func send(method:String='receive',data:Array=[],sendNode:Node=target):
	#stops you if not in_game connected
	if sendNode!=self&&!(in_game&&link_node_in_game):return
	if(!sendNode.is_inside_tree()):return;
	#get_tree().get_multiplayer(get_path()).rpc(0,sendNode,method,data)
	get_tree().get_multiplayer(sendNode.get_path()).rpc(0,sendNode,method,data)
#recieves data from client/server
@rpc(any_peer)
func receive(data=null):
	return

#prints connected when you successfully link to the server host
func OnConnectedToServer(_args=null):
	is_connected=true

#runs when server disconnects with the client and vice versa
func _on_disconnect(_args=null):
	if !is_host:Link.server_closed()
	#cancels any signals outside the game as client no longer exists
	else:link_node_in_game=false
func enteredGame(_args=null):
	in_game=true;
	if(!is_host):link_node_in_game=true
	send("clientInGame",[],self)
@rpc(any_peer)
func clientInGame(_args=null):
	link_node_in_game=true
	if client_already_connected:reset_object_positions()
	client_already_connected=true

#handles fixing the data for an object after client reconnects
func reset_object_positions():
	for item in get_tree().get_nodes_in_group("item"):
		item.update_position(item.global_position)
		item.sync_words(item.Status)

#resets netlink for when you cancel hosting or joining
func endSelf():
	get_tree().get_multiplayer(get_path()).multiplayer_peer=null


#level name for connecting client after they leave
var curLevel:String="res://multiplayer/levels/level1M.tscn"
var inGame=false
#tells server and peers that the connection is now established
@rpc(any_peer)
func establish_link(_args=null):
	is_connected=true
	send("change_level",[curLevel],self)
	if !inGame:
		change_level("res://multiplayer/levels/level1M.tscn")
		inGame=true

@rpc(any_peer)
func update_parameter(param,newValue,targeting=target):
	if(targeting==null):return
	targeting.set(param,newValue);
@rpc(authority)
func change_level(param:String):
	Transitions.transitionScene(param)
	curLevel=param


