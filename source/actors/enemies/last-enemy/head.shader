shader_type canvas_item;

uniform vec4 yellow: hint_color;
uniform float is_yellow: hint_range(0.0, 1.0) = 0.0;
uniform float time; // This is here so that the array on the main script can be complete without crashing.

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb += (yellow.rgb - color.rgb)*is_yellow*step(0.01, length(color.rgb - vec3(0.0)));
	COLOR = color;
}
