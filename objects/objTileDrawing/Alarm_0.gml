/// @description Check for collisions with another

var otherTiles = ds_list_create(); 
instance_place_list(x, y, objTileDrawing, otherTiles, false);

for(var i = 0; i < ds_list_size(otherTiles); ++i) {
    //Compare z locations and delete or be deleted if their z is lower, or my z is lower
    if z < otherTiles[| i].z {
        otherTiles[| i].z = z;
        otherTiles[| i].zHeight += zHeight;
        instance_destroy();
    }
    else if z > otherTiles[| i].z {
        z = otherTiles[| i].z;
        zHeight += otherTiles[| i].zHeight;
        instance_destroy(otherTiles[| i]);
    }
}