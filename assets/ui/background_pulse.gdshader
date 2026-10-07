shader_type canvas_item;
render_mode unshaded;

// Slow breathing neon, confined to the background texture.
uniform float cycle_seconds : hint_range(2.0, 10.0) = 4.0;
uniform float strength : hint_range(0.0, 1.0) = 0.65;
// Negative uses real time; nonnegative supports deterministic preview frames.
uniform float preview_time = -1.0;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float clock = preview_time < 0.0 ? TIME : preview_time;
	float phase = clock * 6.28318530718 / cycle_seconds;
	float breath = 0.5 - 0.5 * cos(phase);
	// Recognize cyan in the artwork rather than washing out the reading area.
	float cyan = smoothstep(0.035, 0.24, min(source.g, source.b) - source.r);
	float gain = mix(1.0, mix(0.78, 1.38, breath), strength * cyan);
	vec3 result = source.rgb * gain;
	float edge = min(UV.x, 1.0 - UV.x);
	float halo = exp(-edge * 65.0);
	float drift = 0.85 + 0.15 * sin(phase - UV.y * 6.28318530718);
	result += vec3(0.02, 0.58, 0.64) * halo * breath * drift * strength * 0.10;
	COLOR = vec4(clamp(result, vec3(0.0), vec3(1.0)), source.a);
}
