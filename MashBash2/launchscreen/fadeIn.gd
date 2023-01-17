@tool
extends RichTextEffect
class_name fadeIn

# Syntax: [ghost freq=5.0 span=10.0][/ghost]

# Define the tag name.
var bbcode := "fadeIn"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var speed=char_fx.env.get("speed")
	var bounce=char_fx.env.get("bounce")
	var delay=char_fx.env.get("delay")
	if(delay==null):delay=0.0
	if(bounce==null):bounce=1.0
	if(speed==null):speed=1.0
	var progress=clamp((-char_fx.relative_index)+(char_fx.elapsed_time-delay)*speed,0.0,1.0)
	var alpha=progress
	char_fx.offset=Vector2(sin(progress*PI)*bounce,cos(progress*PI)*bounce+bounce)
	char_fx.color.a = alpha
	return true
