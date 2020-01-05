foot_big_disc_r = 10;
foot_big_disc_h = 3;

foot_small_disc_r = 1;
foot_small_disc_h = 10;

foot_z_offset = 0;
foot_pilar_z_offset = 5;
foot_rotation_join_z_offset = 60;

foot_column_axis_h = 30;

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
            difference()
            {
                difference() 
                {
                    hull() 
                    {
                        // parallel discs
                        cylinder(r=foot_big_disc_r,2*foot_big_disc_h);
                        // column axis
                        translate([-15,6,0])
                        cube([30,7,3*foot_big_disc_h]);
                    }
                    translate([0,0,5])
                    cylinder(r=foot_big_disc_r,5*foot_big_disc_h);

                }
                
                translate([-15,-8,5])
                cube([30,10,9]);
            }
            // extension axis
            translate([0,25,1.5*foot_big_disc_h])
            mirror([0,1,1])
            cylinder(r=2.62,h=15);
            
        }
        // screw hole
        translate([0,0,-2])
        cylinder(r=screw_hole_r,h=12);
    }
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

// General overview of all elements
foot();

translate([0,4.5,foot_rotation_join_z_offset])
mirror([0,1,1])
foot_rotation_join();
