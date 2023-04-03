shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}
vec3 square(vec2 uv, float width)
{
	uv = uv * 2.0 - 1.0;
	
	vec2 abs_uv = abs(uv.xy);
	float square = step(width, max(abs_uv.x, abs_uv.y));
	return vec3(square);
}
void fragment() {
	float rand=random(floor(UV*vec2(16.,6.))/vec2(16.,6.) + TIME*0.0000001);
	vec3 color=square(floor(UV*vec2(16.,6.))/vec2(16.,6.),rand);
	
	if(color.r>0.){
		COLOR.rgb=texture(SCREEN_TEXTURE,SCREEN_UV).rgb;
		
	}else{
		COLOR.rgb=texture(SCREEN_TEXTURE,SCREEN_UV+random(floor(SCREEN_UV*vec2(16.,6.))/vec2(16.,6.))*0.1*SCREEN_PIXEL_SIZE*vec2(164.,69.)).rgb;
	}
	
}
