extends MultiplayerSynchronizer


# Called when the node enters the scene tree for the first time.
func _ready():
	var root=get_parent().get_node("items")
	var conf=SceneReplicationConfig.new()
	for child in root.get_children():
		if child.get("HeldResource")&&child.HeldResource.syncPos:
			conf.add_property(NodePath(String(child.get_path())+":position"))
	set_replication_config(conf)
