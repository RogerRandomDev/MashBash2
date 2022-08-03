shader_type canvas_item;

void fragment() {

}
//makes the icon float around its box a bit
void vertex() {
	
	
	
	VERTEX=vec2(sin(sin(TIME*PI)*PI/16.+PI/4.+(0.5*PI*float(VERTEX_ID)))*64.+64.,cos(sin(TIME*PI)*PI/16.+PI*1.25+(0.5*PI*float(VERTEX_ID)))*64.+64.);
	VERTEX+=vec2(sin(TIME*PI+UV.x*0.5),cos(TIME*PI+UV.y*0.5))*4.;
}