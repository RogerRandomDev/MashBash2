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
void vertex(){
	world_pos=(MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy; 
}
void fragment( )
{
	vec2 uv = (UV+(world_pos*20.)) * scale;
	uv.x=round(round(uv.x/scale.x)*scale.x)/32.;
	uv.y=round(round(uv.y/scale.y)*scale.y)/32.;
	float shift = cos( floor( uv.y ) );
	uv.x += shift;
	
	float freq = clamp( cos((uv.x * line_freq)) * 3.0, 0.0, 1.0 ) * height;
	float line = 1.0 - clamp( abs( freq - mod( uv.y, 1. ) ) * 11.0, 0.0, 1.0 );
	vec4 ncol=mix(vec4(0.,0.,0.,0.5), vec4(0.,1.,0.625,0.5), line * mod( (uv.x) - TIME * speed * abs( shift ), 1.0 ) /*  * mod( TIME + shift, 1.0 ) */ );
	COLOR=ncol;
	if(doInput){
	float pulse = pulseColor();
	
	uv = UV - 0.5;
	vec4 baseColor = uv.x > 0.0 ? color1 : color2;
	
	vec4 color = pulse*baseColor*0.5*(0.9-cos(uv.x*8.0));
	uv.x *= aspect;
	
	for (int i = 0; i < numBlocks; i++)
	{
		float z = 1.0-0.7*rand(float(i)*1.4333); // 0=far, 1=near
		float tickTime = TIME*z*dataspeed + float(i)*1.23753;
		float tick = floor(tickTime);
		
		vec2 pos = vec2(0.6*aspect*(rand(tick)-0.5), sign(uv.x)*ySpread*(0.5-fract(tickTime)));
		pos.x += 0.24*sign(pos.x); // move aside
		if (abs(pos.x) < 0.1) pos.x++; // stupid fix; sign sometimes returns 0
		pos=round(pos*24.)/24.;
		uv.y=round(uv.y*32.)/32.;
		uv.x=round(uv.x*32.)/32.;
		// vec2 size = 1.8*z*vec2(0.04, 0.04 + 0.1*rand(tick+0.2));
		float b = box(uv-pos, size, 0.01);
		float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
		float block = 0.2*z*smoothstep(0.002, 0.0, b);
		float shine = 0.6*z*pulse*smoothstep(-0.002, b, 0.007);
		color += dust*baseColor + block*z + shine;
	}
	
	color -= rand2(uv)*0.04;
	COLOR=mix(COLOR,color,min(color.a,0.25));
	
	}
}
