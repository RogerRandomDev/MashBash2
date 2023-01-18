/*
	動的電子背景シェーダー by あるる（きのもと 結衣） @arlez80
	Procedural Electric Background Shader by Yui Kinomoto @arlez80

	MIT License
*/
shader_type canvas_item;
uniform float aspect = 2.0;
uniform vec2 size = vec2(0.3);
uniform float dataspeed = 0.7;
uniform float ySpread = 1.6;
uniform int numBlocks = 70;
uniform float basePulse = 0.33;
uniform vec4 color1 = vec4(0.0,0.3, 0.6, 1.0);
uniform vec4 color2 = vec4(0.6, 0.0, 0.3, 1.0);
uniform bool doInput=true;
float rand(float x)
{
    return fract(sin(x) * 4358.5453123);
}

float rand2(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5357);
}

float pulseColor()
{
	float myPulse = basePulse + sin(TIME) * 0.1;
	return myPulse < 1.0 ? myPulse : 1.0;
}

float box(vec2 p, vec2 b, float r)
{
  return length(max(abs(p)-b,0.0))-r;
}
uniform float line_freq = 9.56;
uniform float height = 0.6;
uniform float speed = 0.8;
uniform vec2 scale = vec2( 2.0, 16.0 );
varying vec2 world_pos;
varying mat4 model;
void vertex(){
	world_pos=(MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy; 
	model=MODEL_MATRIX;
}
uniform vec4 bg_color;

float rand3(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}
vec2 to_world(vec2 uv){
	return (model * vec4(uv,296.0,182.0)).xy;
}

void fragment( )
{
	
	bool used=false;
	//original backing shader
	vec2 uv = (UV+(world_pos*20.)) * scale;
//	uv.x=round(round(uv.x/scale.x)*scale.x)/32.;
//	uv.y=round(round(uv.y/scale.y)*scale.y)/32.;
//	float shift = cos( floor( uv.y ) );
//	uv.x += shift;
//	float freq = clamp( cos((uv.x * line_freq)) * 3.0, 0.0, 1.0 ) * height;
//	float line = 1.0 - clamp( abs( freq - mod( uv.y, 1. ) ) * 11.0, 0.0, 1.0 );
//	vec4 ncol=mix(vec4(0.,0.,0.,0.5), vec4(0.,1.,0.625,0.5), line * mod( (uv.x) - TIME * speed * abs( shift ), 1.0 ) /*  * mod( TIME + shift, 1.0 ) */ );
//	COLOR=ncol;
	//stars shader part
	float size2 = 8.0;
	float prob = 0.997;
	vec2 newUV=(UV.xy+(world_pos*20.0))*scale;
	vec2 pos = floor(1.0 / size2 * newUV.xy);
	float color = 0.0;
	float starValue = rand3(pos);

	if (starValue > prob)
	{
		vec2 center = size2 * pos + vec2(size2, size2) * 0.5;
		float t = 0.9 + 0.2 * sin(TIME * 8.0 + (starValue - prob) / (1.0 - prob) * 45.0);
		color = 1.0 - distance(newUV.xy, center) / (0.5 * size2);
		color = color * t / (abs(newUV.y - center.y)) * t / (abs(newUV.x - center.x));
	}
	else if (rand3(SCREEN_UV) > 0.996)
	{
		float r = rand3(SCREEN_UV*20.);
		color = r * (0.85 * sin(TIME * (r * 5.0) + 720.0 * r) + 0.95);
	}
	COLOR = vec4(vec3(color),1.0) + bg_color;
	//title backing
	
	
}
