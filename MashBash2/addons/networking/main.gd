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

#begins hosting the server for the client to join and connect to
func _on_host_button_pressed():
	if Link.is_linked():return
	Link.create_link(true)
	$VBoxContainer/HBoxContainer.visible=false
	$VBoxContainer/space.visible=true
	$VBoxContainer/Label.text="Hosting Game\nIP:"+getIP()
#resets hosting or joining to neither
func resetMode():
	Link.delete_link()
	$VBoxContainer/HBoxContainer.visible=true
	$VBoxContainer/space.visible=false
	$VBoxContainer/Label.text="\n\n"


#returns LAN ip for the host to provide their client
func getIP():
	var ip='localhost'
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4&&address!="127.0.0.1"):
			ip=address
	return ip


#if you press enter when entering ip, connects to current entered ip
func _on_connect_ip_text_changed():
	var ip=$VBoxContainer/connectIP
	if ip.text.contains("\n"):
		ip.text=ip.text.replace("\n","")
		_on_client_button_pressed()
