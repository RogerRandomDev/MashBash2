extends itemStatus

var root=null
#preps crate
func _ready():
	root=get_parent().get_parent()
	root.freeze=false
	super._ready()
	emptyScript()
	if get_parent().Status.has("heavy"):root.freeze=true
