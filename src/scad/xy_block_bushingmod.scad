// xy block  
// Author: sdavi


include <configuration.scad>
include <dimensions.scad>



use_xrod_clamp = true; //use ziptie clamps for xrod?
//clamp_ziptie = true;//use zipties to clamp rod

xy_block(top=1, clamp=use_xrod_clamp); //top
//translate([0,0,-5])mirror([0,0,1]) 
//xy_block(top=0, clamp=use_xrod_clamp); //bottom (nut trap for bearing end)

//clamp();



echo("Bearing Block Length: ", y_bearing_block_length);
echo("Bearing Block Width: ", y_bearing_block_width);
echo("Bearing Block Height: ", y_bearing_block_height);

wall_thickness = 2;


x_height = x_rod_distance+x_bearing[0] + wall_thickness*2+4;
x_width = x_bearing[0] * 2 + 20;//20 for some extra dist to screw down (todo what size?)
x_length = y_bearing_block_width/2+xy_bearing_distance+belt_bearing[1]/2;
x_top_width = GT2_belt_thickness+belt_bearing[1]+M4+6; 

module base(){
	union(){

		translate([2.75,-1,0]) 
            cube([y_bearing_block_length-5.5, y_bearing_block_width+2, y_bearing_block_height]); // bearing Block

            
        translate([0,-1,0])
            hull(){
            translate([y_bearing_block_length/2- GT2_belt_thickness/2 - belt_bearing[1]/2-M4/2-3, 0, x_height/2-1]) 
                cube([x_top_width, x_length, 1]);
            translate([y_bearing_block_length/2-x_width/2,0,0])
                cube([x_width, x_length, y_bearing_block_height]); //rod_block

            }
	}//end union

}





module clamp(){
	difference(){
		intersection(){
			base();
			x_rod_clamp();	
		}
		x_rod_screws();
		//cut hole for x_rod
		translate([y_bearing_block_length/2, x_length+0.1,x_rod_distance/2]) 
			rotate([90,0,0]) cylinder(d=x_bearing[0]+0.4, h=x_length+0.2, $fn=30);
	}
}




module xy_block(top=1, clamp=0){

	difference(){
		base();

		//cut to fit bearings for y_axis
		translate([(y_bearing_block_length-62)/2, y_bearing_block_width/2, 0])
			rotate([0,90,0])
				cylinder(d=y_bushing[1]+0.2, h=62+0.2, $fn=30);

		//cut middle to make easier to print top part without support
		translate([y_bearing_block_length/2-y_bearing[2]+5/2,-1.1,-.1])
			cube([y_bearing[2]*2-5, y_bearing_block_width+2.2, 3.1]);

		//cut hole for x_rod
		translate([y_bearing_block_length/2, x_length+.1,x_rod_distance/2]) 
			rotate([90,0,0]) 
                cylinder(d=x_bearing[0]+0.2, h=x_length+1.2, $fn=30);

		//clear X bearing area
		color("orange")translate([y_bearing_block_length/2-x_width/2-0.1,y_bearing_block_width,-.1])
			cube([x_width+0.2, x_length, min_beltbearing_height/2+.1]);
	
		//cut m4 screw hole to mount belt bearings
		for(x=[y_bearing_block_length/2- GT2_belt_thickness/2 - belt_bearing[1]/2,
			   y_bearing_block_length/2+ GT2_belt_thickness/2 + belt_bearing[1]/2]){
			
			translate([x, y_bearing_block_width/2+xy_bearing_distance,0]){
				cylinder(d=M4, h=x_height);
				//cut hole for head/nut
				if(top==1){
					translate([0, 0,x_height/2-4])
						cylinder(d=9, h=4.1, $fn=60);//3.4 min height for head
				} else {
					translate([0, 0,x_height/2-4])
						cylinder(d=m4_nut_diameter_horizontal, h=4, $fn=6);//3.4 min height for head
				}

			}
		}

		//screws for y bearing clamp (m3) (as jand next to bearings)
		translate([y_bearing_block_length/2, y_bearing_block_width/2, 0]){
			for(x=[-y_bearing[2]-M3/2, +y_bearing[2]+M3/2]){
				for(y=[y_bearing[0]/2+4.5, -y_bearing[0]/2-4.5]){
					translate([x,y,-.1])
                        cylinder(d=M3, h=x_height, $fn=60);
				}
			}
		}
		
		if(clamp==true){
			//make cutout for clamp and holes for screws
			translate([0,0,0]) x_rod_clamp();
			//if(clamp_ziptie==true){
				x_rod_ziptie();
			//} else {
				//x_rod_screws();
			//}
		}
	}//end difference
}



module x_rod_clamp(){

		//cut rod clamp for x-rod(with 45 deg slope so can print main piece without support)
		ch=(x_height-x_rod_distance)/2+.01;
		che = tan(45)*ch;

		
		translate([x_length+y_bearing_block_length/2-x_length/2,y_bearing_block_width,x_rod_distance/2])rotate([90,0,-90])linear_extrude(height=x_length, slices = 20)
			polygon( points=[[0,0],
				[y_bearing_block_width+1.1,0],
              	[y_bearing_block_width+1.1,ch],
				[-che,ch]] 
			);						
}

/*
module x_rod_screws(){

	//screws for x rod clamp (m3) 
	translate([y_bearing_block_length/2, y_bearing_block_width/2, 0]){

		for(x=[(-x_top_width/2-x_bearing[0]/2)/2, (x_top_width/2+x_bearing[0]/2)/2]){
			translate([x,0,0])cylinder(d=M3, h=x_height, $fn=60);
				
			//cut under for embedded screw
			//Hex Head M3x30: Head 5.5mm flat to flat, 2.12mm thick
			translate([x,0,0])cylinder(d=m3_hex_head_diameter, h=y_bearing[1]/2+3.3, $fn=6);

		}
	}
}
*/


module x_rod_ziptie(){

	translate([y_bearing_block_length/2, y_bearing_block_width/2, x_rod_distance/2])
		difference(){
			rotate([90,0,0])cylinder(d=x_bearing[0]+14, h=6, $fn=30, center=true);
			rotate([90,0,0])cylinder(d=x_bearing[0]+8, h=6, $fn=40, center=true);
		}
}


