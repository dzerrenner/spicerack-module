// Spice Rack, CC-BY-4.0, dave@ledave.rocks
// Rounded cube by groovenectar: https://gist.github.com/groovenectar/92174cb1c98c1089347e
// Screw holes by nomike: https://github.com/nomike/openscad-screw-holes

use <rounded_cube.scad>;
include <screw_holes.scad>;

// Thickness of the top and bottom face
thickness_top_bottom = 2.5;

// thickness of the walls, keep in mind that the screws move in too (e.g. you need longer ones with thicker walls)
thickness_walls = 5;

// downwards angle of the bottom
angle = 2.5;

// tzotal width from left to right. 163mm fit exactly in a GNADSBY.
width = 163;

// total height
height = 60;

// depth from front to back. 155mm fit loosely in a GNADSBY.
depth = 155;

// where to put a stopper block. This prevents the jars from falling in
depth_stopper=88;

// debug: render the spice jars, turn off for final render
show_flasks = true;

// Set to 0.01 for higher definition curves (renders slower)
$fs = 0.15;

module spiceflask() {
    width = 45;
    height = 110;
    plug_height = 18;
    plug_gap = 3;
    plug_diameter = 47;
    plug_gap_diameter = plug_diameter * 0.75;
    union() {
        // main body
        roundedcube([width,width,height-plug_height-plug_gap], radius = 3);
        // part between body and to ("gap")
        translate([width/2,width/2,height-plug_height-plug_gap]) {
            cylinder(h=plug_gap, d=plug_gap_diameter);
        }
        // plug
        translate([width/2,width/2,height-plug_height]) {
            cylinder(h=plug_height, d=plug_diameter);
        }    
    }
}

// shell
difference() {
    // outer volume
    roundedcube([width, depth, height], radius=1.5);

    // inner volume
    translate([thickness_walls, 0, thickness_top_bottom]) 
        cube([width-2*thickness_walls, depth, height-2*thickness_top_bottom]);
    
    // screw holes
    translate([thickness_walls, 8, height/2]) 
        rotate([0,-90,0])  
            screw_hole(DIN965, M4, 10);

    translate([width-thickness_walls, 8, height/2]) 
        rotate([0,90,0])  
            screw_hole(DIN965, M4, 10);
            
}

// shelf
zpos=8;
translate([0,0,zpos]) rotate([-1*angle, 0, 0])  {
    // flasks 
    if (show_flasks) {
        for(xpos=[width/2 - 1.5*50 + 1.5:50:120]) {
            color("Grey") translate([xpos,depth_stopper,thickness_top_bottom+1]) rotate([90,0,0]) spiceflask();
        }        
    }
    // shelf floor
    roundedcube([width, 153, thickness_top_bottom], radius=1.5);
    // back stopper
    translate([0, depth_stopper,  0])    cube([width, thickness_top_bottom, 15]);
}

// bottom filler
translate([thickness_top_bottom/2, 0, thickness_top_bottom/2]) 
    cube([width-thickness_top_bottom, thickness_top_bottom, 8]);

// back column
translate([width/2 - thickness_walls/2, depth_stopper+thickness_top_bottom, thickness_top_bottom/2]) 
    cube([thickness_walls, depth-depth_stopper-thickness_top_bottom, height-thickness_top_bottom]);






