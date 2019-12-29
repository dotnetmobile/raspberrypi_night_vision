foot_big_disc_r = 6;
foot_big_disc_h = 3;

foot_small_disc_r = 1;
foot_small_disc_h = 10;

foot_z_offset = 0;
foot_column_z_offset = 10;
foot_rotation_join_z_offset = 60;

axis_h = 40;

module foot()
{
    difference()
    {
        translate([-22,-22,foot_z_offset])
        cube([44,44,6]);
        translate([0,0,foot_z_offset+3])
        cylinder(r=8,h=7);
     
    }
}

module foot_column()
{
    translate([0,0,foot_column_z_offset])
    {
        cylinder(r=7.5,h=3);
        union()
        difference() 
        {
            cylinder(r=4, h=axis_h);
            cylinder(r=3, h=axis_h);
        }
    }
}

module foot_rotation_join()
{
    union()
    {
        // parallel discs
        cylinder(r=foot_big_disc_r,foot_big_disc_h);
        translate([0,0,6])
        cylinder(r=foot_big_disc_r,foot_big_disc_h);
        // axis
        translate([0,12,4.5])
        mirror([0,1,1])
        cylinder(r=2,h=10);
    }
}


foot();

foot_column();

translate([0,4.5,foot_rotation_join_z_offset])
mirror([0,1,1])
foot_rotation_join();
