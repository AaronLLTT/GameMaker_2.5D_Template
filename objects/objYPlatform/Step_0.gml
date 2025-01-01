/// @description Insert description here

y += moveDirection * moveSpeed;

//Move the player if there is a collision
if Collisions_3D(x, y, z, objPlayerTest) {
    with(objPlayerTest) {
        y += other.moveDirection * other.moveSpeed;
    }
}

--moveDistance;

if moveDistance < 0 {
    moveDirection *= -1;
    moveDistance = 60;
}

UpdateLayers(y, z - zHeight);