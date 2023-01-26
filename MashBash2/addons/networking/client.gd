#server client object
extends baseNet
class_name client
	
func _ready():
	var multiplayerPeer = ENetMultiplayerPeer.new();
	get_tree().get_multiplayer(get_path()).connect('connected_to_server',OnConnectedToServer);
	multiplayerPeer.create_client("localhost", 25565);
	get_tree().get_multiplayer(get_path()).multiplayer_peer = multiplayerPeer;
	get_tree().get_multiplayer(get_path()).connect('server_disconnected',_on_disconnect);






