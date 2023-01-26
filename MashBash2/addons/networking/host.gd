#server host object
extends baseNet
class_name host

func _ready():
	is_host=true
	var multiplayerPeer = ENetMultiplayerPeer.new();
	multiplayerPeer.create_server(25565, 2);
	get_tree().get_multiplayer(get_path()).connect('peer_disconnected',_on_disconnect)
	get_tree().get_multiplayer(get_path()).connect('peer_connected',establish_link);
	get_tree().get_multiplayer(get_path()).multiplayer_peer = multiplayerPeer;


