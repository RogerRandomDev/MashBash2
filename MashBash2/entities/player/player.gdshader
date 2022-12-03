/* 
Rainbow outline by @Farfalk and @ThePadDev, And Edit for @LURGX in 2022

Apply to canvas items with transparent backgrounds.
Check that there is sufficient transparent background space for the outline!

CC0 License (but citation is welcome <3)
All code is property of @Farfalk and @ThePadDev
Thanks for shader and I'm a newbie with shaders 
*/

shader_type canvas_item;

uniform float line_scale : hint_range(0, 20) = 0.875;    // thickness of the line

void fragment() {
	
	vec4 line_color=vec4(vec3(1.)-texture(SCREEN_TEXTURE,SCREEN_UV).rgb,1.);
	vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	if(color.a==0.){COLOR = mix(color, line_color , outline - color.a);}
	
	
}