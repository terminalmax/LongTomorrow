shader_type canvas_item;

void vertex() {
	UV.x += sin(TIME * 0.5);
	UV.y -= TIME * 0.1;
}
