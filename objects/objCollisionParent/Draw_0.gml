/// @description Draw self lifted
if !surface_exists(shadowSurface)
{
    shadowSurface = surface_create(sprite_width + border, sprite_height + border);
}

surface_set_target(shadowSurface)
draw_sprite(sprite_index, 0, (sprite_width+border) / 2, (sprite_height + border) / 2);
surface_reset_target();
shader_set(shdShadows);
shader_set_uniform_f(shader_get_uniform(shdShadows, "size"), sprite_width + border, sprite_height + border, 10);
draw_surface(shadowSurface, x - surface_get_width(shadowSurface) / 2, y - surface_get_height(shadowSurface) / 2);
shader_reset();

draw_sprite(sprite_index, 0, x, y - z);