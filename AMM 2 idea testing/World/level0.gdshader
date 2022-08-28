shader_type canvas_item;

void fragment() {
	vec2 uv=UV;
	
	uv.y=uv.y-modf((TEXTURE_PIXEL_SIZE.y),uv.y);
	COLOR=texture(TEXTURE,uv);
	
}
