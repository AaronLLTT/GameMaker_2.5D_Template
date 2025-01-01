/// @description Set Z Properties & Layer
z = 0;
var collision = instance_place(x, y, objTileParent);

if collision {
    z = collision.z + collision.zHeight; 
}

UpdateLayers(y, z - zHeight);

surf=-1
border=25