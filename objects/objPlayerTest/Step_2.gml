/// @description Update Layer
//Update the layer if I'm actually colliding with one of these tile objects
//Which can only occur when walking down and getting behind them, because the collisions allow that
//And not the moving up into them.
var tileCollisionDepth = 0;
var collision = instance_place(x, y, objTileDrawing);

if collision && collision.z + collision.zHeight > z + zHeight {
    tileCollisionDepth = -collision.zHeight;
}
else {
    tileCollisionDepth = 0;
}

var bridgeCollision = instance_place(x, y - z, objTileDrawing);
if bridgeCollision && bridgeCollision.z > z {
    bridgeCollision = -bridgeCollision.z * 5;
}
else {
    bridgeCollision = 0;
}

//Check if we're colliding with other objects and update the layer then

var objectCollision = instance_place(x, y - sprite_height / 2, objCollision);
var objectDepth = 0;

if objectCollision {
    objectDepth = objectCollision.z + objectCollision.zHeight;
}


UpdateLayers(y, zFloor + tileCollisionDepth + bridgeCollision + objectDepth);