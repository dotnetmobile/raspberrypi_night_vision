use <threadlib/threadlib.scad>

foot_big_disc_r = 10;
foot_big_disc_h = 3;

foot_z_offset = 0;
foot_rotation_join_z_offset = 60;

foot_column_axis_h = 30;

screw_hole_r = 5.5;

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
            cylinder(r=foot_big_disc_r,3*foot_big_disc_h);
            translate([-8,6,0])
            cube([16,7,3*foot_big_disc_h]);

            // extension axis
            translate([0,25,1.5*foot_big_disc_h])
            mirror([0,1,1])
            cylinder(r=2.62,h=15);
        }
        
        // screw hole
        translate([0,0,-2])
        #cylinder(r=screw_hole_r,h=12);
    }
}

//thread_model = "G1/2-ext";

thread_model = "G1/8-ext";
thread_turns = 40;

module screw()
{
    thread(thread_model, turns=thread_turns);
    specs = thread_specs(thread_model);
    P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
    section_profile = specs[3];
    H = (thread_turns + 1) * P;
    translate([0, 0, -P / 2])
        cylinder(h=H, d=Dsupport, $fn=120);
}

// The STL steps are used for generating each printing element
/* 
    STL step 1: foot generation

    foot();
    
*/

/*
    STL step 2: rotation join

    foot_rotation_join();
*/

module general_overview()
{
    // General overview of all elements
    foot();

    translate([0,4.5,foot_rotation_join_z_offset])
    mirror([0,1,1])
    foot_rotation_join();
}

general_overview();

translate([0,10,foot_rotation_join_z_offset])
mirror([0,1,1])
screw();