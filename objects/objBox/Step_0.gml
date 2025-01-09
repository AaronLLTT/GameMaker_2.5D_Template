/// @description Be pushed around

if !moving {
    xSpeed = 0;
    ySpeed = 0;
}
 
var underMe = Get_Highest_Height(x + xSpeed, y + ySpeed, objTileDrawing);
if underMe < z {
    zSpeed -= global.Gravity;
}

//Stop when on the ground
if z + zSpeed <= underMe {
    zSpeed = 0;
    z = underMe;
}

Player_Collisions([objTileDrawing, objCollisionParent, objPlayerTest]);

x += xSpeed;
y += ySpeed;
z += zSpeed;

//Check for collisions after being pushed behind tiles
var topTile = instance_place(x, y, objTopTile);
if topTile && topTile.z + topTile.zHeight > z + zHeight {
    topTile = topTile.z + topTile.zHeight;
}
else {
    topTile = 0;
}

UpdateLayers(y, z - zHeight - 4 - topTile);