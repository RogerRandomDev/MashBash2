@tool
extends Position2D
class_name itemResource


@export var HeldResource:Resource=itemContents.new()

@export var Status:PackedStringArray
var sprite=Sprite2D.new()
var descriptives=HBoxContainer.new()
var descriptiveLabel=Label.new()
var size=Vector2.ZERO
#prepares basic setup for items
func _ready():
	sprite.texture=HeldResource.Sprites["default"]
	size=Vector2(sprite.texture.get_width(),sprite.texture.get_height())*scale
	sprite.centered=false
	add_child(sprite)
	add_child(descriptives)
	add_child(descriptiveLabel)
	descriptiveLabel.position.y=-16
	updateDescriptives()



#removes and loads the new descriptives
func updateDescriptives():
	descriptiveLabel.text=""
	for child in descriptives.get_children():child.queue_free()
	for descriptive in Status:applyDescriptive(descriptive)
	descriptiveLabel.text+=HeldResource.Name
	call_deferred("update_label")

#called with deffered so that it has a frame to update the size first
func update_label():
	descriptiveLabel.position.x=-descriptiveLabel.size.x/2+size.x/2


func removeDescriptive(id):
	var out = descriptives[id]
	descriptives.remove_at(id)
	updateDescriptives()
	return out

#will either change sprite if it has one for the descriptive, elsewise is just adds the icon above to show it
func applyDescriptive(descriptive):
	#if sprite changes with descriptive, it will show it here
	if HeldResource.has_sprite(descriptive):
		pass
	#applies basic descriptive icons as well
	descriptives.add_child(HeldResource.make_descriptive_icon(descriptive))
	descriptiveLabel.text+="%s "%descriptive
