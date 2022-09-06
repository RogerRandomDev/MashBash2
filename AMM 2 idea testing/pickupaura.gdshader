shader_type canvas_item;

void fragment() {
	COLOR.a=min(sin(UV.x*PI*2.),sin(UV.y*PI));
}
