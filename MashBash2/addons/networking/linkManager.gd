extends Node

var link_root:baseNet=null

#establishes the link node between the host and the client
func create_link(as_host:bool=false):
	if link_root!=null:return ERR_ALREADY_EXISTS
	if as_host:link_root=host.new()
	else:link_root=client.new()
	link_root.link_node=link_root
	add_child(link_root)

func is_linked():return link_root!=null
#removes the link node when no longer needed
func delete_link():
	link_root.queue_free();link_root=null


func set_target(target:Node):link_root.target=target
func get_target():return link_root.target
func set_local(local:Node):link_root.local=local
func get_local():return link_root.local


