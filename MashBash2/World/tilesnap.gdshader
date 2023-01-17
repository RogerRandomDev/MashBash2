shader_type canvas_item;


void fragment(){
	COLOR=texture(TEXTURE,(UV*vec2(192,12))/vec2(191.99,11.99));
}
