/// @description Update Layer
var bridgeCollision = instance_place(x, y, objTileParent);
if bridgeCollision && bridgeCollision.z > z {
    bridgeCollision = 1000;
}
else {
    bridgeCollision = 0;
}


UpdateLayers(y, zFloor + zHeight - bridgeCollision);