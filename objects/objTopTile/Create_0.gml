/// @description Destroy Other Objects
myTile = undefined; //The specific tile from the tileset it's drawing
myTileSet = undefined; //The tileset being used to draw
z = undefined;
zHeight = undefined;

var tileCollision = instance_place(x, y, objTileDrawing);

if tileCollision {
    myTile = tileCollision.myTile
    myTileSet = tileCollision.myTileSet
    z = tileCollision.z;
    zHeight = tileCollision.zHeight;
    instance_destroy(tileCollision);
}

UpdateLayers(y, z + zHeight);