shader_type canvas_item;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy*TIME,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	COLOR.a=pow(length(abs(UV-vec2(0.5))),4.0)*random(UV);
	
}
