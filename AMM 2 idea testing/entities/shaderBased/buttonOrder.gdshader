shader_type canvas_item;

uniform int columns=4;
uniform int rows=1;
uniform int binaryUsed=3;
uniform vec3 color=vec3(0.);
uniform float alphaVal=1.0;
void fragment() {
	int val=binaryUsed;
	int bit=int(UV.x/TEXTURE_PIXEL_SIZE.x*float(columns));
	bit+=columns*int(UV.y/TEXTURE_PIXEL_SIZE.y*float(rows));
	int active=0;
	while(val>0||active<columns+rows*columns){
		int rem=val%2;
		val=(val-rem)/2;
		if(active==bit){
			COLOR=vec4(color*float(rem),min(
				ceil(abs(sin(UV.x/TEXTURE_PIXEL_SIZE.x*PI*float(columns)))-0.125),
				ceil(abs(sin(UV.y/TEXTURE_PIXEL_SIZE.y*PI*float(rows)))-0.125))*alphaVal);
			}
		active++;
		
	}
	
}
