shader_type canvas_item;

uniform vec4 color : source_color; 
uniform bool is_active = true;

void fragment() {
	vec4 current = texture(TEXTURE, UV);
	
	if (is_active) {
		const float x = 1.0/float(textureSize(TEXTURE, 0).x);
		const float y = 1.0/float(textureSize(TEXTURE, 0).y);
	
		float alpha = -4.0 * current.a;
		alpha += texture(TEXTURE, UV + vec2(x, 0)).a;
		alpha += texture(TEXTURE, UV + vec2(-x, 0)).a;
		alpha += texture(TEXTURE, UV + vec2(0, y)).a;
		alpha += texture(TEXTURE, UV + vec2(0, -y)).a;
	
		COLOR = vec4(color.rgb, clamp(alpha, 0.0, 1.0));
	}
	else {
		COLOR = current;
	}
	
	//vec4 final = mix(current, color, clamp(alpha, 0.0, 1.0));
	//COLOR = vec4(final.rgb, clamp(abs(alpha) + current.a, 0.0, 1.0));
	//COLOR = final;
}
