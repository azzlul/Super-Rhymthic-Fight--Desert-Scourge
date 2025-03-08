shader_type canvas_item;
uniform float progress: hint_range(0.0, 1.0, 0.1) = 1;
void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	if(alpha > 0.0) alpha = 1.0;
	COLOR = vec4(1, 1, 1, alpha);
	vec4 target_color = mix( texture(TEXTURE, UV), vec4(1,1,1,alpha),progress);
	COLOR = target_color;
}
