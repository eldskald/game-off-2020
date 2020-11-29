shader_type canvas_item;

uniform float speed;

void fragment() {
	COLOR = texture(TEXTURE, vec2(mod(UV.x + TIME*speed*TEXTURE_PIXEL_SIZE.x, 1.0), UV.y));
}
