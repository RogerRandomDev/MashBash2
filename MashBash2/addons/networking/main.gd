extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_client_button_pressed():
	if Link.is_linked():return
	Link.create_link(false,$HBoxContainer/connectIP.text)
	$HBoxContainer.visible=false


func _on_host_button_pressed():
	if Link.is_linked():return
	Link.create_link(true)
	$HBoxContainer.visible=false
	$Label.text="Hosting Game. IP:"+getIP()


func getIP():
	var ip_adress :String
	
	if OS.has_feature("windows"):
		if OS.has_environment("COMPUTERNAME"):
			ip_adress =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("x11"):
		if OS.has_environment("HOSTNAME"):
			ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("OSX"):
		if OS.has_environment("HOSTNAME"):
			ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	return ip_adress
