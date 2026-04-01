shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 1.0); // diagonal direction
uniform float speed = 0.5;               // scroll speed

void fragment() {
    vec2 uv = UV;

    // Normalize direction so speed is consistent
    vec2 dir = normalize(direction);

    // Offset UV over time
    uv += dir * TIME * speed;

    COLOR = texture(TEXTURE, uv);
}