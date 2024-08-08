shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	
	vec4 noise_point = texture(noise, UV);
	
	COLOR = noise_point;
}

