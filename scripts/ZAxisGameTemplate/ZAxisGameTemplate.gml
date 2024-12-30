/**
 * Set the primary controls for playing the game
 * @param {any*} up The up key
 * @param {any*} down The down key
 * @param {any*} right The right key
 * @param {any*} left The left key
 * @param {any*} jump The jump button
 */
function Define_Player_Controls(up, down, right, left, jump) {
	global.MoveRight = right;
	global.MoveLeft = left;
	global.MoveUp = up;
	global.MoveDown = down;
	global.Jump = jump;
}

/**
 * Define how moving in the game feels, including coyote time if you want it
 * @param {any*} walkSpeed How fast the character walks
 * @param {any*} jumpHeight How high the character can jump (use a negative value)
 * @param {any*} gameGravity How fast the character is pulled back down to the earth
 * @param {real} [coyoteTime]=30 The default coyote time for allowing easier platforming, set to 0 for none
 */
function Define_Player_Movement(walkSpeed, jumpHeight, gameGravity, coyoteTime = 30) {
	global.WalkSpeed = walkSpeed;
	global.JumpHeight = jumpHeight;
	global.Gravity = gameGravity;
    //Set this to 0 to disable coyote time in your game
    global.CoyoteTime = coyoteTime; //How long you can jump after leaving a platform
    var myFunc = function() {
        //show_debug_message("Timer done.")
    }
    global.CTTimeSource = time_source_create(time_source_game, global.CoyoteTime, time_source_units_frames, myFunc);
	
	//Player Instance Variables
	z = 0; //Where the player is currently in the z axis
	zSpeed = 0; //The current speed in the z axis
	zHeight = abs(bbox_top - bbox_bottom); //Used for calculating collisions
	zFloor = 0; //The place to land on
	xSpeed = 0; //The x directional movement
	ySpeed = 0; //The y directional movement
    
    //Used for drawing the drop shadow
    surf=-1
    border=25
}

/**
 * Set up the tile layers that the player can collide with
 * @param {real} tileWidth The width of tiles in your game
 * @param {real} tileHeight The height of tiles in your game
 * @param {array} tileLayers All the tile layers to include in collisions
 */
function Define_Tile_Layers(tileWidth, tileHeight) {
	global.TileWidth = tileWidth;
	global.TileHeight = tileHeight;
	global.TileSize = (tileWidth + tileHeight) / 2;
	global.TileZHeight = tileHeight * 2;
    //Get every tile layer and filter out the rest
	global.Layers = layer_get_all();
    function is_tile_layer_to_keep(layerToTest) {
        var matchingTileLayer = false;
        var nonCollisionLayer = false;
        if layerelementtype_tilemap == layer_get_element_type(layerToTest) {
            matchingTileLayer = true;
        }
        if string_count("_", layer_get_name(layerToTest)) > 0 {
            nonCollisionLayer = true;
        }
        
        return matchingTileLayer && nonCollisionLayer;
    }
    global.Layers = array_filter(global.Layers, is_tile_layer_to_keep);
    
    //Hide the tile layers that have a Z Height from being drawn by default because we will draw them manually with different depths
	for(var i = 0; i < array_length(global.Layers); ++i) {
        layer_set_visible(global.Layers[i], false);
	}
}

/**
 * Set the camera look and window, fullscreen is set to false by default, and camera speed is .008
 * @param {real} viewWidth The width of the game window
 * @param {real} viewHeight The height of the game window
 * @param {real} cameraWidth The width of the camera
 * @param {real} cameraHeight The height of the camera
 * @param {real} startingRoom The room your game begins in, usually a menu
 * @param {bool} [fullScreen]=false Full screen the game or not
 * @param {GM.Room} [cameraSpeed]=0.08 How fast the camera follows the follow (keep it low, like .01)
 */
function Define_Camera(viewWidth, viewHeight, cameraWidth, cameraHeight, startingRoom, fullScreen = false, cameraSpeed = 0.08) {
	global.CameraWidth = cameraWidth;
	global.CameraHeight = cameraHeight;
	global.ViewWidth = viewWidth;
	global.ViewHeight = viewHeight;
	global.CamSpeed = cameraSpeed;
	global.Camera = camera_create_view(0, 0, cameraWidth, cameraHeight);
	room_set_view_enabled(startingRoom, true);
	room_set_viewport(startingRoom, 0, true, 0, 0, viewWidth, viewHeight);
    room_set_camera(startingRoom, 0, global.Camera);
	window_set_fullscreen(fullScreen);
	surface_resize(application_surface, viewWidth, viewHeight);
    
    room_goto(startingRoom);
}

/**
 * Ensure the camera we created is applied to the rooms
 */
function Set_Camera() {
	view_enabled = true;
	view_visible[0] = true;
	view_camera[0] = global.Camera;
}

/**
 * Zoom in and out. It's a bit clunky, but works
 */
function Camera_Controls() {
    if mouse_wheel_up() {
        global.CameraWidth -= (16 * 4);
        global.CameraHeight -= (9 * 4);
        camera_set_view_size(global.Camera, global.CameraWidth, global.CameraHeight);
    }
    if mouse_wheel_down() {
        global.CameraWidth += (16 * 4);
        global.CameraHeight += (9 * 4);
        camera_set_view_size(global.Camera, global.CameraWidth, global.CameraHeight);
    }
}

/**
 * Create all the objects that will draw the tiles in our room and set their z, zHeight, and update their layers appropriately
 * Depth sorting system graciously stolen from MirthCastle - https://www.youtube.com/watch?v=JcEb0ayqsGY&t=81s (worth a watch for the info alone)
 */
function Define_Depth_Sorting() {
	global.Cell = 4;
	global.GridHeight = room_height div global.Cell;
	global.LayerGrid = ds_grid_create(1, global.GridHeight);
	
	for(var i = 0; i < global.GridHeight; ++i) {
		global.LayerGrid[#0,i] = layer_create(layer_get_depth("sort_begin") - i);
	}
    
    //Create tile drawing objects at every spot a tile exists
    for(var h = 0; h < array_length(global.Layers); ++h) {
        for(var i = -global.TileWidth / 2; i < room_width + global.TileWidth; i += global.TileWidth) {
            for(var j = -global.TileHeight / 2; j < room_height + global.TileHeight; j += global.TileHeight) {
                var tile = instance_place(i, j, layer_tilemap_get_id(global.Layers[h]));
                if tile {
                    //Get the properties of the tile based on the layer name 
                    /* Z is the z location it sits on the ground in, H is the height it goes into the air*/
                    var drawing = instance_create_layer(i, j, "Instances", objTileDrawing);
                    var layerName = layer_get_name(global.Layers[h]);
                    var tileProps = string_split(layerName, "_");
                    var tileZ =  real(string_digits(tileProps[1]));
                    var tileZHeight = real(string_digits(tileProps[2]));
                    drawing.z = tileZ;
                    drawing.zHeight = tileZHeight;
                    var tileID = layer_tilemap_get_id(global.Layers[h]);
                    drawing.myTileID = tileID;
                    var tileToDraw = tilemap_get_at_pixel(layer_tilemap_get_id(global.Layers[h]), i, j + global.TileHeight); //Compensate for a weird collision checking bug
                    drawing.myTile = tileToDraw;
                    var tileSet = tilemap_get_tileset(layer_tilemap_get_id(global.Layers[h]));
                    drawing.myTileSet = tileSet;
                    with(drawing) {
                        //Put the actual object where I will check for collisions
                        y = j + global.TileHeight / 2;
                        x = i - global.TileWidth / 2;
                        UpdateLayers(y - zHeight, z + zHeight); //Change where the tile lives on the layer for depth sorting to account for its z and height
                    }
                }
            }
        }
    }
}

/**
 * Set the object in the correct layer based on their y and z properties
 * @param {any*} newY The y location of the object
 * @param {any*} newZ Its z properties (zFloor, z, zHeight, or any combination of them)
 */
function UpdateLayers(newY, newZ) {
	//Clamp to layers inside of room
	var yCheck = (newY + newZ) div global.Cell;
	yCheck = clamp(yCheck, 0, ds_grid_height(global.LayerGrid) - 1);
	layer = global.LayerGrid[#0, yCheck]; 
}

/**
 * The primary moving logic of the player with properties like collisions, diagonal movement, jumping, and coyote time
 */
function Player_Movement() {
	var hMovement = keyboard_check(global.MoveRight) - keyboard_check(global.MoveLeft);
	var vMovement = keyboard_check(global.MoveDown) - keyboard_check(global.MoveUp);
	var jump = keyboard_check_pressed(global.Jump);
	
	xSpeed = hMovement * global.WalkSpeed;
	ySpeed = vMovement * global.WalkSpeed;
	
	//Normalize the diagonal movement speed
	if xSpeed != 0 && ySpeed != 0 {
		xSpeed *= .707;
		ySpeed *= .707;
	}
	
	//Z Based Jumping
	//Get any object I'm colliding with below me and set it as my floor
	zFloor = Get_Object_Height(x, y, objTileDrawing);

	var onGround = z == zFloor;
	
	//Jump up
	if jump && onGround {
		zSpeed = -global.JumpHeight;
        time_source_start(global.CTTimeSource)
        time_source_stop(global.CTTimeSource);
	}
    //Enabled coyote time
    else if jump && zSpeed != 0 {
        if time_source_get_time_remaining(global.CTTimeSource) > 0 && time_source_get_state(global.CTTimeSource) == time_source_state_active {
            zSpeed = -global.JumpHeight;
            time_source_stop(global.CTTimeSource);
        }
    }
	//Fall back down
	if !onGround {
		zSpeed -= global.Gravity;
        //Starting the coyote time timer
        if time_source_get_state(global.CTTimeSource) == time_source_state_initial {
            time_source_start(global.CTTimeSource);
        }
		
		//Land on the floor
		if z + zSpeed <= zFloor {
			while(z + sign(zSpeed) >= zFloor) {
				z += sign(zSpeed);
			}
			z = zFloor;
			zSpeed = 0;
            time_source_reset(global.CTTimeSource);
		}
	}
    
    PlayerCollisions(objTileDrawing);
    Player_Object_Collisions(objCollision);
	
	Camera_Update();
	
	x += xSpeed;
	y += ySpeed;
	z += zSpeed;
}

/**
 * Check for collisions along all 3 axis and diagonally
 * @param {any*} The object to check for
 * @returns {bool} True if there's a collision, false if none
 */
function PlayerCollisions(object) {
	var collision = false;
	//X Collisions
	if Collisions_3D(x + xSpeed, y, z, object) {
		while(!Collisions_3D(x + sign(xSpeed), y, z, object)) {
			x += sign(xSpeed);
		}
		xSpeed = 0;
		collision = true;
	}
	//Y Collisions
	if Collisions_3D(x, y + ySpeed, z, object) {
		while(!Collisions_3D(x, y + sign(ySpeed), z, object)) {
			y += sign(ySpeed);
		}
		ySpeed = 0;
		collision = true;
	}
	//Z Collisions
	if Collisions_3D(x, y, z + zSpeed, object) {
		while(!Collisions_3D(x, y, z + sign(zSpeed), object)) {
			z += sign(zSpeed);
		}
		zSpeed = 0;
        time_source_reset(global.CTTimeSource); //Used for Coyote Time
		collision = true;
	}
	//Diagonal Collisions
	if Collisions_3D(x + xSpeed, y + ySpeed, z + zSpeed, object) {
		while(!Collisions_3D(x + sign(xSpeed), y + sign(ySpeed), z + sign(zSpeed), object)) {
			x += sign(xSpeed);
			y += sign(ySpeed);
			z += sign(zSpeed);
		}
		xSpeed = 0;
		ySpeed = 0;
		zSpeed = 0;
		collision = true;
	}
	return collision;
}

/**
 * Checks the 3D world for collisions with the player and returns the ID of the collider or false
 * @param {real} newX The X position to check
 * @param {real} newY The Y position to check
 * @param {real} newZ The Z position to check
 * @param {any*} collisionToCheck The ID to check a collision for
 */
function Collisions_3D(newX, newY, newZ, collisionToCheck) {
    var firstXYMeeting = false;
    var xyMeeting = false;
    var zMeeting = false;
    firstXYMeeting = instance_place(newX, newY, collisionToCheck);
    
    //Check again with zHeight of that collision to allow moving behind taller tile set layers
    if firstXYMeeting {
        xyMeeting = instance_place(newX, newY - firstXYMeeting.zHeight - firstXYMeeting.z, collisionToCheck);
        
        //Run a set of checks to see if there's a blank space between the first collision and the second. If there is, then the two are not connected
        //so continue on as normal until the player is colliding correctly
        if xyMeeting {
            for(var i = 0; i < firstXYMeeting.zHeight / global.TileHeight; i += global.TileHeight) {
                if !instance_place(firstXYMeeting.x, firstXYMeeting.y - ((i + 1) * global.TileHeight), objTileDrawing) {
                    xyMeeting = false;
                }
            }
        }
    }
    
    if xyMeeting {
        //The final z check
        var otherZ = xyMeeting.z + xyMeeting.zHeight - 0.25;
        zMeeting = rectangle_in_rectangle(0, xyMeeting.z - 0.25, 1, xyMeeting.z + xyMeeting.zHeight - 0.25, 0, newZ, 1, newZ + zHeight); //Maybe add zHeight?
    }
    
    if xyMeeting && zMeeting {
        return xyMeeting;
    }
    else {
        return false;
    }
}

function Object_Collisions_3D(newX, newY, newZ, object) {
    var firstXYMeeting = false;
    var zMeeting = false;
    var secondXYMeeting = false;
    
    firstXYMeeting = instance_place(newX, newY, object);
    
    if firstXYMeeting {
        zMeeting = rectangle_in_rectangle(0, secondXYMeeting.z - 0.25, 1, secondXYMeeting.z + secondXYMeeting.zHeight - 0.25,
        0, newZ, 1, newZ + zHeight);
    }
    
    return firstXYMeeting && zMeeting;
}

function Player_Object_Collisions(object) {
    var collision = false;
    //X Collisions
    if Object_Collisions_3D(x + xSpeed, y, z, object) {
        while(!Object_Collisions_3D(x + sign(xSpeed), y, z, object)) {
            x += sign(xSpeed);
        }
        xSpeed = 0;
        collision = true;
    }
    //Y Collisions
    if Object_Collisions_3D(x, y + ySpeed, z, object) {
        while(!Object_Collisions_3D(x, y + sign(ySpeed), z, object)) {
            y += sign(ySpeed);
        }
        ySpeed = 0;
        collision = true;
    }
    //Z Collisions
    if Object_Collisions_3D(x, y, z + zSpeed, object) {
        while(!Object_Collisions_3D(x, y, z + sign(zSpeed), object)) {
            z += sign(zSpeed);
        }
        zSpeed = 0;
        time_source_reset(global.CTTimeSource); //Used for Coyote Time
        collision = true;
    }
    //Diagonal Collisions
    if Object_Collisions_3D(x + xSpeed, y + ySpeed, z + zSpeed, object) {
        while(!Object_Collisions_3D(x + sign(xSpeed), y + sign(ySpeed), z + sign(zSpeed), object)) {
            x += sign(xSpeed);
            y += sign(ySpeed);
            z += sign(zSpeed);
        }
        xSpeed = 0;
        ySpeed = 0;
        zSpeed = 0;
        collision = true;
    }
    return collision;
}

/**
 * Move the camera to the player and lock it within the room boundaries
 */
function Camera_Update() {
	//Move the camera
	var viewX = camera_get_view_x(view_camera[0]);
	var viewY = camera_get_view_y(view_camera[0]);
	var viewWidth = camera_get_view_width(view_camera[0]);
	var viewHeight = camera_get_view_height(view_camera[0]);

	var gotoX = x + (xSpeed) - (viewWidth * 0.5);
	var gotoY = y + (ySpeed) - (viewHeight * 0.5) - z; //Adjust camera for y + z

	var newCamX = lerp(viewX, gotoX, global.CamSpeed);
	var newCamY = lerp(viewY, gotoY, global.CamSpeed);
	
	//Clamp to keep camera in room
	newCamX = clamp(newCamX, 0, room_width - viewWidth);
	newCamY = clamp(newCamY, 0, room_height - viewHeight);

	camera_set_view_pos(view_camera[0], newCamX, newCamY);
}

/**
 * Disable all objects outside of the current camera view to ensure performance doesn't take a big hit in larger rooms
 */
function Disable_Enable_Objects() {
    cameraLeft = camera_get_view_x(global.Camera);
    cameraTop = camera_get_view_y(global.Camera);
    
    instance_deactivate_region(cameraLeft + xSpeed, cameraTop + ySpeed, global.CameraWidth + xSpeed, global.CameraHeight + ySpeed, false, true);
    instance_activate_region(cameraLeft + xSpeed, cameraTop + ySpeed, global.CameraWidth + xSpeed, global.CameraHeight + ySpeed, true);
}

/**
 * Used to set the zFloor variable for the player which controls if they're on the ground, can jump, and depth
 * @param {real} newX The x position to check, usually x + xSpeed
 * @param {real} newY The y position to check, usually y + ySpeed
 * @param {any*} The object to check for a collision with and get its height
 * @returns {real} The height of the object it found
 */
function Get_Object_Height(newX, newY, objectToCheck) {
    var firstObjectCollision = instance_place(newX, newY, objectToCheck);
    var objectCollision = 0;
    var objectHeight = 0;

    if firstObjectCollision {
        objectCollision = instance_place(newX, newY - firstObjectCollision.zHeight - firstObjectCollision.z, objectToCheck);
        //Run a set of checks to see if there's a blank space between the first collision and the second. If there is, then the two are not connected
        //so continue on as normal until the player is colliding correctly
        if objectCollision {
            for(var i = 0; i < firstObjectCollision.zHeight / global.TileHeight; i += global.TileHeight) {
                if !instance_place(firstObjectCollision.x, firstObjectCollision.y - ((i + 1) * global.TileHeight), objectToCheck) {
                    objectCollision = false;
                }
            }
        }
    }
	
	if objectCollision && (objectCollision.zHeight + objectCollision.z) <= z {
		objectHeight = objectCollision.z + objectCollision.zHeight;
	}

	return objectHeight;
}