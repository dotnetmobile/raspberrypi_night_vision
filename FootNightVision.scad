foot_big_disc_r = 10;
foot_big_disc_h = 3;

foot_small_disc_r = 1;
foot_small_disc_h = 10;

foot_z_offset = 0;
foot_pilar_z_offset = 5;
foot_rotation_join_z_offset = 60;

foot_column_axis_h = 40;

screw_hole_r = 2;

module foot()
{
    union()
    {
        // basis
        translate([-22,-22,foot_z_offset])
        linear_extrude(6)
        offset(2,$fn=24)
        square(44,44);
        // pilar
        difference() 
        {
            cylinder(r=4, h=foot_column_axis_h);
            cylinder(r=3, h=foot_column_axis_h);
        }
    }
}

module foot_rotation_join()
{
    difference()
    {
        union()
        {
            // parallel discs
            cylinder(r=foot_big_disc_r,foot_big_disc_h);
            translate([0,0,6])
            cylinder(r=foot_big_disc_r,foot_big_disc_h);
            // column axis
            translate([0,13,4.5])
            mirror([0,1,1])
            cylinder(r1=3,r2=4.5,h=7);
            // extension axis
            translate([0,25,4.5])
            mirror([0,1,1])
            cylinder(r=2.62,h=15);
            
        }
        // screw hole
        translate([0,0,-2])
        cylinder(r=screw_hole_r,h=12);
    }
}


backside_width = 80;
backside_height = 25;
deepth_backside = 20;

backside_offset_x = -backside_width/2;
backside_offset_y = -backside_height/2;

module backside_slots()
{
    translate([backside_offset_x/2+10, backside_offset_y+2, -5])
        cube([2,20,8]);
    translate([-backside_offset_x/2-12, backside_offset_y+2, -5])
        cube([2,20,8]); 
}

module backside_rotation_join()
{
    union()
    {
        translate([0,0,6])
        cube([2.3,6,6], center=true);
        
        translate([0,0,13])
        mirror([1,0,1])
        difference()
        {
            cylinder(r=5.5,h=2.30,center=true);
            cylinder(r=screw_hole_r,h=3, center=true);
        }
    }
}

module foot_head_holder()
{
    translate([-15,-13,0])
    cube([30,26,3]);
    backside_slots();
    backside_rotation_join();
}

/* 
    STL step 1: foot generation

    foot();
    
*/

/*  
    STL step 2: foot pilar generation

    foot_pilar_z_offset = 0;
    foot_pilar();
    
*/

/*
    STL step 3: rotation join

    foot_rotation_join();
*/

//foot();

//translate([0,4.5,foot_rotation_join_z_offset])
//mirror([0,1,1])
//foot_rotation_join();

foot_head_holder();