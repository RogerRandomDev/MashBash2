extends itemStatus

func _ready():
	super._ready()
	emptyScript()
	call_deferred('addCollision',0.5)
