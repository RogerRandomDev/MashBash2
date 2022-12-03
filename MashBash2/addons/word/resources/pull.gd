extends RichTextEffect
class_name pull

var bbcode ="pull"


func _process_custom_fx(char_fx):
	char_fx.set_color(Color(0.75-sin(char_fx.elapsed_time*PI)*0.25,0.,0.,1.))
	char_fx.set_offset(Vector2(sin(char_fx.elapsed_time),cos(char_fx.elapsed_time+PI/4.))*4.)
