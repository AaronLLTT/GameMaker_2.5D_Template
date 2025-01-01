/// @description Move To and Fro
x += moveDirection * moveSpeed;

//Move the player if there is a collision
if Collisions_3D(x, y, z, objPlayerTest) {
    with(objPlayerTest) {
        x += other.moveDirection * other.moveSpeed;
    }
}

--moveDistance;

if moveDistance < 0 {
    moveDirection *= -1;
    moveDistance = 60;
}