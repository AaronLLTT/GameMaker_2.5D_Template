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


--moveDistance;
if moveDistance < 0 {
    moveDirection *= -1;
    moveDistance = 60;
}

UpdateLayers(y, z - zHeight);