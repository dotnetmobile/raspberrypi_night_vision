/*
    Modeling the raspeberry pi night vision camera
    By dotnetmobile@gmail.com December 2019 
*/

camera_diameter = 16.5;

big_circle_diameter = 20;
small_circle_diameter = 9;

big_circle_x_pos = 30;
big_circle_y_pos = 0;

//small_circle_x_pos = big_circle_x_pos - big_circle_diameter / 2;
small_circle_x_pos = 20.5;
small_circle_y_pos = 10;

camera_x_pos = 0;
camera_y_pos = 0;

// back side
backside_width = 80;
backside_height = 25;
backside_offset_x = -backside_width/2;
backside_offset_y = -backside_height/2;
//backside_offset_z = -18;
backside_offset_z = 0;

map_cube_x = 34;
map_cube_y = 8;
map_cube_z = 9;

irColor = "green";
cameraColor = "green";

backside_extrude_height = 15;

foot_big_disc_r = 10;
foot_big_disc_h = 3;

screw_hole_r = 5.5;

module rotation_cylinder()
{
    difference()
    {
        cylinder(r=foot_big_disc_r,3*foot_big_disc_h);
        // screw hole
        translate([0,0,-2])
        cylinder(r=screw_hole_r,h=12);
    }
}

module roundedRectangle(width, height)  
{
    offset(2,$fn=24)
    square([width, height], center=false);
}

module irSensors()
{
    union()
    {
        // big circles
        translate([big_circle_x_pos,big_circle_y_pos,0])
        color(irColor)
        circle(d=big_circle_diameter);
        
        // small circles
        translate([0.95*small_circle_x_pos, 0.7*small_circle_y_pos, 0]) 
        color(irColor)
        circle(d=small_circle_diameter);
    }
}

module camera()
{
    translate([camera_x_pos, camera_y_pos, 0]) 
    color(cameraColor)
    circle(d=camera_diameter);
}

module night_vision_camera()
{
    irSensors();
    mirror([0,1,0]) mirror([1,0,0]) irSensors();
    camera();
}

module front_side()
{   
    difference() 
    {
        linear_extrude(height=2)
        color("green")
        translate([backside_offset_x, backside_offset_y, 1]) 
        roundedRectangle(backside_width, backside_height);
        
        linear_extrude(height=8) 
        night_vision_camera();
    }
}

module slots()
{
    translate([backside_offset_x-6,backside_offset_y+10,backside_offset_z])
    cube([5,4,3]);
    translate([-backside_offset_x,backside_offset_y+10,backside_offset_z])
    cube([5,4,3]);
}

module twin_pillars()
{
    translate([backside_offset_x-2,backside_offset_y-2,2])
    cube([4,4,16]);
    translate([-backside_offset_x-2,backside_offset_y-2,2])
    cube([4,4,16]);
}

module clipsing_pilars()
{
    twin_pillars();
    mirror([0,1,0])
    twin_pillars();
}

module back_rotation()
{
    translate([13,0,4+backside_height])
    {
        mirror([1,0,1])
        {
            translate([0,0,6*foot_big_disc_h])
            rotation_cylinder();
            rotation_cylinder();
        }
        translate([-27,-5,-13])
        cube([9,10,5]);
        translate([-9,-5,-13])
        cube([9,10,5]);
    }
}


module back_side()
{
    difference()
    {   
        // outside     
        translate([backside_offset_x-2,backside_offset_y-2,0])
        scale(1.2)
        color("blue")
        linear_extrude(height=backside_extrude_height)
        roundedRectangle(backside_width-10, backside_height);

        // inside
        scale(1.02)
        color("green")
        linear_extrude(height=backside_extrude_height)
        translate([backside_offset_x, backside_offset_y, 0])
        roundedRectangle(backside_width, backside_height);        
    }
    // internal pilars for stopping front-side when clipsing it
    union()
    {
        clipsing_pilars();
        mirror([1,0,0]) clipsing_pilars();
    }

    back_rotation();
}

module single_support()
{
    translate([big_circle_x_pos,big_circle_y_pos,backside_extrude_height-5])
    cylinder(5,r=4);
}

module back_side_supports()
{
    single_support();
    mirror([1,0,0]) single_support();
}

module back_side_case()
{
    translate([0,0,backside_offset_z]) union()
    {
        back_side();

        back_side_supports();
    }
}

module extern_map_cube()
{
    translate([-map_cube_x/2-4,backside_offset_y*1.92,backside_offset_z+3]) 
    {
        color("red")
        scale(1.2)
        cube([map_cube_x,map_cube_y,map_cube_z]);
    }
}

module intern_map_cube()
{
        translate([-map_cube_x/2 -4 + 3.5,backside_offset_y*2.7,backside_offset_z+5]) 
        {
            cube([map_cube_x,map_cube_y*2.5,map_cube_z*0.7]);
        }
}

module nape_case()
{
    difference()
    {
        extern_map_cube();
        intern_map_cube();
    }
}

module night_vision_without_nape() 
{
    difference()
    {   back_side_case();
        
        // open the case for including the nape
        extern_map_cube();
    }
}

module night_vision_with_nape() 
{
    night_vision_without_nape();
    nape_case();
}

module night_vision_with_nape_and_holes()
{
    difference()
    {
        night_vision_with_nape();
        slots();
    }
}

module general_overview_front_side()
{
    // main part
    front_side();
    backside_offset_z = -18;
    mirror([0,0,1])
    night_vision_with_nape_and_holes();
}

general_overview_front_side();