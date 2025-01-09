/// @description Move
z += moveDirection * moveSpeed;

//Move the player if there is a collision
if Collisions_3D(x, y, z, objPlayerTest) {
    with(objPlayerTest) {
        z += other.moveDirection * other.moveSpeed;
        zFloor = z;
    }
}

//If the player is directly underneath the platform
var player = instance_place(x, y, objPlayerTest);
if player && player.z < z {
    moveSpeed = 0;
}
else {
    --moveDistance;
    moveSpeed = 1;
}

if moveDistance < 0 {
    moveDirection *= -1;
    moveDistance = 60;
}

UpdateLayers(y, z - zHeight);