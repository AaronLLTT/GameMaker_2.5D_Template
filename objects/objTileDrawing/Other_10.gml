/// @description Check for a tile above itself & make top tiles

var tileAbove = instance_place(x, y - zHeight, objTileDrawing);

if !tileAbove {
    var tilesToMake = zHeight / global.TileHeight;
    for(var i = 0; i < tilesToMake; ++i) {
        instance_create_layer(x, y - (i * global.TileHeight), layer, objTopTile);
    }
}