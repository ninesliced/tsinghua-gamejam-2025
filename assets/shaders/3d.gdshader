shader_type canvas_item;

uniform sampler2D ground_cols;
uniform int number_of_ground_cols = 8;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;

uniform vec4 uniform_shadow : source_color;
uniform vec3 color_fill : source_color;
uniform float force: hint_range(0,1.0);
uniform float height: hint_range(0, 10, 1);


bool match_color(vec3 color, vec3 target_color) {
	return distance(color, target_color) < 0.01;
}

int get_ground_index(vec4 color) {
	int ground_index = 0;
	for (int i = 0;  i < number_of_ground_cols; i++) {
		vec3 ground_col = texelFetch(ground_cols, ivec2(0, i), 0).rgb;
		ground_index = int(mix(float(ground_index), float(i), float(match_color(color.rgb, ground_col))));
	}
	return ground_index;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);

	vec4 above_pixel = texture(screen_texture,vec2(SCREEN_UV.x, SCREEN_UV.y - SCREEN_PIXEL_SIZE.y * height));
	int ground_index = get_ground_index(above_pixel);

	vec3 shadow_col = texelFetch(ground_cols, ivec2(2, ground_index), 0).rgb;


//
	////wall
	for (int i = 0; i < int(height + 1.0); i+= 2) {
		vec4 above_pixel = texture(screen_texture,vec2(SCREEN_UV.x, SCREEN_UV.y - SCREEN_PIXEL_SIZE.y * float(i)));
		int above_index = get_ground_index(above_pixel);
		vec3 ground_col = texelFetch(ground_cols, ivec2(1, above_index), 0).rgb;
		vec3 wall_col = texelFetch(ground_cols, ivec2(0, above_index), 0).rgb;

		if (above_pixel.a == 1.0 && COLOR.a == 0.0 && match_color(above_pixel.rgb, wall_col)) {
			COLOR.rgba = vec4(ground_col, 1.0);
			COLOR.rgb = mix(COLOR.rgb, shadow_col.rgb, 1.0);
		}
	}
	
	
	//custom woin't be used
	vec4 s_color = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = mix(COLOR.rgb, color_fill, force);
	
	// scotch
	// above_pixel = texture(screen_texture,vec2(SCREEN_UV.x, SCREEN_UV.y - SCREEN_PIXEL_SIZE.y * (height + 1.0)));
	// vec4 right_pixel = texture(screen_texture,vec2(SCREEN_UV.x + SCREEN_PIXEL_SIZE.x, SCREEN_UV.y));
	// vec4 left_pixel = texture(screen_texture,vec2(SCREEN_UV.x - SCREEN_PIXEL_SIZE.x, SCREEN_UV.y));
	// vec4 down_pixel = texture(screen_texture,vec2(SCREEN_UV.x, SCREEN_UV.y + SCREEN_PIXEL_SIZE.y));
	// if (above_pixel.a == 1.0 && COLOR.a == 0.0) {
	// 	COLOR.rgba = vec4(0.0,0.0,0.0,1.0);
	// }
	// if (right_pixel.a == 1.0 && COLOR.a == 0.0) {
	// 	COLOR.rgba = vec4(0.0,0.0,0.0,1.0);
	// }
	// if (left_pixel.a == 1.0 && COLOR.a == 0.0) {
	// 	COLOR.rgba = vec4(0.0,0.0,0.0,1.0);
	// }
	// if (down_pixel.a == 1.0 && COLOR.a == 0.0) {
	// 	COLOR.rgba = vec4(0.0,0.0,0.0,1.0);
	// }
}
