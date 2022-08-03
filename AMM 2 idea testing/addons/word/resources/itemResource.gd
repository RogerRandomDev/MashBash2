@tool
extends Position2D
class_name itemResource


@export var HeldResource:Resource=itemContents.new()

@export var Status:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
var size=Vector2.ZERO
#prepares basic setup for items
func _ready():
	sprite.texture=HeldResource.Sprites["default"]
	size=Vector2(sprite.texture.get_width(),sprite.texture.get_height())*scale
	sprite.centered=false
	add_child(sprite)
	add_child(descriptives)
	updateDescriptives()



#removes and loads the new descriptives
func updateDescriptives():
	for child in descriptives.get_children():child.queue_free()
	for descriptive in Status:applyDescriptive(descriptive)




#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	#if sprite changes with descriptive, it will show it here
	if HeldResource.has_sprite(descriptive):
		pass
	#applies basic descriptive icons as well
	descriptives.add_child(HeldResource.make_descriptive_icon(descriptive))
