shader_type canvas_item;

uniform sampler2D ground_cols;
uniform int number_of_ground_colors = 4;

void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 current_color = texture(ground_cols, UV);
	vec4 pixel_color = texture(TEXTURE, UV);

	if (pixel_color.a > 0.1) {
		COLOR = COLOR;
	} else {
		vec4 above_pixel_color = texture(TEXTURE, vec2(UV.x, UV.y - TEXTURE_PIXEL_SIZE.y));

		for (int i = 0; i < number_of_ground_colors; i++) {
			vec4 ground_color = texelFetch(ground_cols, ivec2(i, 0), 0);
			if (above_pixel_color == ground_color) {
				COLOR = vec4(0.0,1.0,1.0,1.0);
			}
		}
		
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
