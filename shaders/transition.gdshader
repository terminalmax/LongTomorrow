shader_type canvas_item;

uniform float amount = 0.0;

void fragment() {
	
	const float x = UV.x - 0.5;
	const float y = UV.y - 0.5;
	
	float alpha = step(abs(x), amount);
	
	COLOR = vec4(vec3(0.0), alpha);
	
}
