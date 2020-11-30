shader_type canvas_item;

const float PI = 3.14159265359;

uniform float origin: hint_range(0.0, 1.0) = 0.15;
uniform float amplitude: hint_range(0.0, 5.0) = 0.0;
uniform float wavelength: hint_range(0.001, 10.0) = 1.0;
uniform float frequency: hint_range(0.0, 10.0) = 0.0;
uniform float phase: hint_range(0.0, 10.0) = 0.0;

void fragment() {
	vec2 uv = floor(UV/TEXTURE_PIXEL_SIZE);
	float dx = floor(amplitude*(clamp(4.0*(UV.y - origin), 0.0, 1.0)));
	dx *= sin(PI*(uv.y + (TIME + phase)*frequency)/wavelength);
	COLOR = texture(TEXTURE, (uv + vec2(dx, 0.0))*TEXTURE_PIXEL_SIZE);
}
