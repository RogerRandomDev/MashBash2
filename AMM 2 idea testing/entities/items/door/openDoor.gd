extends itemStatus

func _ready():
	super._ready()
	emptyScript()
	if get_parent().Status.has("locked"):
		get_parent().sprite.texture=get_parent().HeldResource.Sprites["default"]
		addCollision(0.5)
	else:if get_parent().Status.has("open"):
		get_parent().emit_signal("use_item",null,"openDoor")
