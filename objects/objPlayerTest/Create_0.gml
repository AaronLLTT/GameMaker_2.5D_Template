/// @description Initialize
Define_Player_Controls(ord("W"), ord("S"), ord("D"), ord("A"), vk_space, mb_left);

Define_Player_Movement(3.5, -4.5, .25, 3);

Define_Tile_Layers(16, 16);

//Must be set in a room before this player object is created
//Define_Camera(1920, 1080, 640, 360, false);

Define_Depth_Sorting();

Delete_Top_Tiles();