/// @description Set Z Properties & Layer
z = 0;
var collision = instance_place(x, y, objTileParent);

if collision {
    z = collision.z + collision.zHeight; 
}

//Subtracting zHeight for objects works better than adding
UpdateLayers(y, z - zHeight);

shadowSurface = -1;
border = 25;