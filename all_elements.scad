use <FootNightVision.scad>
use <NightVision.scad>

general_overview_foot();

translate([0,0,60])
mirror([0,1,1])
general_overview_front_side();