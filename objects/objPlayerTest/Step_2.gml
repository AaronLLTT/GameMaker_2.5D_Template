/// @description Update Layer
//Update the layer if I'm actually colliding with one of these tile objects
//Which can only occur when walking down and getting behind them, because the collisions allow that
//And not the moving up into them.
var tileCollisionDepth = 0;
var collision = instance_place(x, y, objTileDrawing);

if collision && collision.z + collision.zHeight > z + zHeight {
    tileCollisionDepth = -collision.zHeight;
}

var bridgeCollision = instance_place(x, y - z, objTileDrawing);
if bridgeCollision && bridgeCollision.z > z {
    bridgeCollision = -bridgeCollision.z * 5;
}
else {
    bridgeCollision = 0;
}


UpdateLayers(y, zFloor + tileCollisionDepth + bridgeCollision);