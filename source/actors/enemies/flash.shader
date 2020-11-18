shader_type canvas_item;

uniform vec4 yellow: hint_color;

// Using floats here instead of bools to make the code shorter and more efficient.
uniform float flash_white: hint_range(0.0, 1.0) = 0.0;
uniform float flash_yellow: hint_range(0.0, 1.0) = 0.0;
uniform float flash_invisible: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	float is_yellow = mod(floor(4.0*TIME)*flash_yellow, 2.0);
	float is_invisible = mod(floor(16.0*TIME)*flash_invisible, 2.0);
	
	color.rgb += (yellow.rgb - color.rgb)*is_yellow;
	color.rgb += (vec3(1.0) - color.rgb)*flash_white;
	color.a *= 1.0 - is_invisible;
	
	COLOR = color;
}
