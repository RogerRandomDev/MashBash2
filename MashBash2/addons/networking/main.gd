extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_client_button_pressed():
	if Link.is_linked():return
	Link.create_link(false,$VBoxContainer/connectIP.text)
	$VBoxContainer/HBoxContainer.visible=false


func _on_host_button_pressed():
	if Link.is_linked():return
	Link.create_link(true)
	$VBoxContainer/HBoxContainer.visible=false
	$Label.text="Hosting Game IP:"+getIP()


func getIP():
	var ip
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4&&address!="127.0.0.1"):
			ip=address
	return ip
