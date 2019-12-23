/*
    Modeling the raspeberry pi night vision camera
    By dotnetmobile@gmail.com December 2019 
*/

camera_diameter = 16;

ir_light_diameter = 20;
ir_small_diameter = 10;

x_pos_ir = 30;
y_pos_ir = 0;

x_pos_ir_small = x_pos_ir - ir_light_diameter / 2;
y_pos_ir_small = 10;

x_pos_camera = 0;
y_pos_camera = 0;

// back side
width_backside = 80;
height_backside = 25;
deepth_backside = 20;
offset_x_backside = -width_backside/2;
offset_y_backside = -height_backside/2;
offset_z_backside = 0;

map_cube_x = 33;
map_cube_y = 16;
map_cube_z = 8;

irColor = "green";
cameraColor = "green";

extrude_height = 15;

module roundedRectangle(width, height)  
{
    offset(2,$fn=24)
    square([width, height], center=false);
}

module irSensors()
{
    union()
    {
        // large circles
        translate([x_pos_ir,y_pos_ir,0])
        color(irColor)
        circle(d=ir_light_diameter);
        
        // small circles
        translate([0.9*x_pos_ir_small, 0.5*y_pos_ir_small, 0]) 
        color(irColor)
        circle(d=ir_small_diameter);
    }
}

module camera()
{
    translate([x_pos_camera, y_pos_camera, 0]) 
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
        translate([offset_x_backside, offset_y_backside, 1]) 
        roundedRectangle(width_backside, height_backside);
        
        linear_extrude(height=8) 
        night_vision_camera();
    }
}

module slots()
{
    translate([offset_x_backside-6,offset_y_backside+10,offset_z_backside])
    cube([5,4,3]);
    translate([-offset_x_backside,offset_y_backside+10,offset_z_backside])
    cube([5,4,3]);
}

module clipsing_pilar()
{
    translate([offset_x_backside-2,offset_y_backside-2,2])
    cube([4,4,16]);
    translate([-offset_x_backside-2,offset_y_backside-2,2])
    cube([4,4,16]);
}

module clipsing_pilars()
{
    clipsing_pilar();
    mirror([0,1,0])
    clipsing_pilar();
}

module back_side()
{
    difference()
    {
        translate([offset_x_backside-2,offset_y_backside-2,0])
        scale(1.2)
        color("blue")
        linear_extrude(height=extrude_height)
        roundedRectangle(width_backside-10, height_backside);

        scale(1)
        color("green")
        linear_extrude(height=extrude_height)
        translate([offset_x_backside, offset_y_backside, 0])
        roundedRectangle(width_backside, height_backside);
    }
    // internal pilars for stopping front-side when clipsing it
    union()
    {
        clipsing_pilars();
        mirror([1,0,0]) clisping_pilars();
    }
}

module single_support()
{
    translate([x_pos_ir,y_pos_ir,extrude_height-5])
    cylinder(5,r=4);
}

module back_side_supports()
{
    single_support();
    mirror([1,0,0]) single_support();
}

module back_side_case()
{
    translate([0,0,offset_z_backside]) union()
    {
        back_side();

        back_side_supports();
    }
}

module extern_map_cube()
{
    translate([-map_cube_x/2-4,offset_y_backside*2.6,offset_z_backside+3]) 
    {
        color("red")
        scale(1.2)
        cube([map_cube_x,map_cube_y,map_cube_z]);
    }
}

module intern_map_cube()
{
        translate([-map_cube_x/2 -4 + 3.5,offset_y_backside*2.7,offset_z_backside+5]) 
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

// main part
front_side();
night_vision_with_nape_and_holes();

