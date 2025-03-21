shader_type canvas_item;
uniform sampler2D dust: source_color, repeat_enable;
uniform vec2 direction;
uniform float speed;
uniform float alpha: hint_range(0, 1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 poz = fract(UV + normalize(direction) * TIME/100.0*speed);
	vec4 col = texture(dust, poz);
	COLOR = col * alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
