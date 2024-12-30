/// @description Draw Tiles
draw_tile(myTileSet, myTile, 0, x, y);

//Debugging
draw_self();
draw_set_font(fntDebug);
draw_text(x + 8, y + 8, string_digits(layer));