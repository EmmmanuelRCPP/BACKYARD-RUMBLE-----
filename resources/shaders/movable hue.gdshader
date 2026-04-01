shader_type canvas_item;

uniform sampler2D palette_in;
uniform sampler2D palette_out;

uniform int palette_size = 4;

// tolerancia por canal (mucho más preciso que distance)
uniform float tolerance : hint_range(0.0, 0.1) = 0.01;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 color = tex_color.rgb;

    vec3 result = color;

    for (int i = 0; i < 64; i++) {
        if (i >= palette_size) break;

        float x = (float(i) + 0.5) / float(palette_size);

        vec3 in_color = texture(palette_in, vec2(x, 0.5)).rgb;

        // Comparación EXACTA por canal
        if (
            abs(color.r - in_color.r) < tolerance &&
            abs(color.g - in_color.g) < tolerance &&
            abs(color.b - in_color.b) < tolerance
        ) {
            result = texture(palette_out, vec2(x, 0.5)).rgb;
            break;
        }
    }

    COLOR = vec4(result, tex_color.a);
}