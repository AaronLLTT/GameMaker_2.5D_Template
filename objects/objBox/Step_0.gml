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

UpdateLayers(y, z - zHeight - 4);