shader_type canvas_item;

void fragment() {
	// Place fragment code here.
}

void vertex(){
	vec2 change=vec2(abs(sin(TIME*PI/3.)*2.)-1.,sin(TIME*PI/2.)*2.-1.);
	VERTEX+=change.x*vec2(sign(VERTEX.x),sign(VERTEX.y));
	VERTEX.y+=floor(change.y-16.);
}
