shader_type canvas_item;

uniform vec4 color : source_color;

uniform float t = 0.1;
uniform float h = 0.7;
uniform float opacity = 0.8;

void fragment() {
	
	float alpha = 0.0;
	
	// Shaft
	if ( abs(UV.y - 0.5) < t && UV.x < h ) {
		alpha = opacity;
	}
	// Head
	if ( abs(UV.y - 0.5) + UV.x < 1.0 && UV.x > h) {
		alpha = opacity;
	}
	
	COLOR = vec4(color.rgb, alpha);
}


