extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_client_button_pressed():
	if Link.is_linked():return
	Link.create_link(false)
	$HBoxContainer.visible=false


func _on_host_button_pressed():
	if Link.is_linked():return
	Link.create_link(true)
	$HBoxContainer.visible=false


