// Configuration
// Author: sdavi


include <dimensions.scad>
use <library.scad>


x_rod_distance = 45;

y_bearing = LM8UU;
y_bushing = BUSHING;
x_bearing = LM8UU;
x_bushing = BUSHING;
z_bearing = LM12LUU;
z_bushing = BUSHING;
belt_bearing = BEARING_2x624;


end_belt_bearing_distance = 25;// distance between 2 bearings on y-ends
belt_clearance = 9.5; //space for belts

frame_screw = M5; //m5 screws for v/tslot

frame_spacer_height = 18; //height to spacer to mount to frame to clear x-ends 


// calculated vars

//y bearing block
y_bearing_block_length = 2*y_bushing[2] + M3*2;
y_bearing_block_width = y_bearing[1]+5;
y_bearing_block_height = 6+y_bushing[1]/2;

xy_bearing_distance = y_bearing_block_width/2+belt_clearance+belt_bearing[1]/2; //distance between center of y-bearing to center of x-belt bearing 


//min height for belt bearings
min_beltbearing_height = max(((belt_bearing[2]+m4_washer_thickness*2) * 2), y_bearing_block_height);
