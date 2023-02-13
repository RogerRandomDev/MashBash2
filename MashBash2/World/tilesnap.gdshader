shader_type canvas_item;


void fragment(){
	COLOR=texture(TEXTURE,(UV*(1./(TEXTURE_PIXEL_SIZE))*(TEXTURE_PIXEL_SIZE+vec2(0.000001))));
}
