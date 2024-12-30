/// @description Insert description here
// You can write your code in this editor
draw_sprite(sprite_index, 0, x, y - z);
draw_set_alpha(0.5);
draw_rectangle_color(bbox_left, bbox_top, bbox_right, bbox_bottom, c_blue, c_blue, c_blue, c_blue, false);
draw_set_alpha(1);
draw_set_font(fntDebug);
draw_text(x, y, string_digits(layer));