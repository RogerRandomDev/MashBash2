/*
	動的電子背景シェーダー by あるる（きのもと 結衣） @arlez80
	Procedural Electric Background Shader by Yui Kinomoto @arlez80

	MIT License
*/
shader_type canvas_item;

uniform vec4 background_color = vec4( 0.0, 0.0, 0.0, 1.0 );
uniform vec4 line_color = vec4( 0.0, 1.0, 1.0, 1.0 );
uniform float line_freq = 9.56;
uniform float height = 0.6;
uniform float speed = 0.8;
uniform vec2 scale = vec2( 2.0, 16.0 );
varying vec2 world_pos;
void vertex(){
	world_pos=(MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy; 
}
void fragment( )
{
	vec2 uv = (UV+(world_pos*20.)) * scale;
	uv.x=round(uv.x*32.)/32.;
	uv.y=round(uv.y*32.)/32.;
	float shift = cos( floor( uv.y ) );
	uv.x += shift;
	
	float freq = clamp( cos((uv.x * line_freq)) * 3.0, 0.0, 1.0 ) * height;
	float line = 1.0 - clamp( abs( freq - mod( uv.y, 1. ) ) * 11.0, 0.0, 1.0 );
	COLOR = mix( background_color, line_color, line * mod( (uv.x) - TIME * speed * abs( shift ), 1.0 ) /*  * mod( TIME + shift, 1.0 ) */ );
}
