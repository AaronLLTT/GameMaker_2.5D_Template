/// @description Draw Self and Shadow
draw_sprite(sprite_index, image_index, x, y - z);

if zSpeed != 0 {
	if !surface_exists(surf)
	{
	    surf=surface_create(sprite_width+border,sprite_height+border)
	}

	surface_set_target(surf)
	draw_sprite(sprite_index,0,(sprite_width+border)/2,(sprite_height+border)/2)
	surface_reset_target()
	shader_set(shdShadows)
	shader_set_uniform_f(shader_get_uniform(shdShadows,"size"),sprite_width+border,sprite_height+border,10)
	draw_surface(surf,x-surface_get_width(surf)/2,y-surface_get_height(surf)/2)
	shader_reset()
}