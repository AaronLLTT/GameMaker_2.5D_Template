/// @description Debugging
draw_set_font(fntMainMenu);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(8, 8, "Layer: " + string(layer));
draw_text(8, 48, "Z: " + string(z));
draw_text(8, 82, "Z Floor: " + string(zFloor));
draw_text(8, 108, "Z Speed: " + string(zSpeed));
if z == zFloor && zSpeed == 0 {
	draw_text(8, 140, "On Ground");
}
draw_text(8, 166, " FPS: " + string(fps_real));
draw_text(8, 190, "Objects Alive: " + string(instance_count));