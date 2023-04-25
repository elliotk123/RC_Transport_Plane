use <airfoil.scad>;
$fn=100;
wing_length = 80;
control_surface_length = 60;
control_surface_angle =  0;


module raw_wing(){
    rotate([90,0,0])translate([0,0,-wing_length/2])airfoil(p=[0.04,0.4,12],chord=60,length=wing_length,taper=1,sweep=0);
}

module axis(){
   translate([46,0,2])rotate([90,0,0])cylinder(h=69,r=1,center=true); 
}

module axis_hole(){
    translate([46,0,2])rotate([90,0,0])cylinder(h=70,r=1.5,center=true); 
}

difference(){difference(){
    raw_wing();
    rotate([90,0,0])translate([50,0,0])cylinder(h=control_surface_length,r=10,center=true);}
    axis_hole();
}
union(){translate([49,0,0])rotate([0,control_surface_angle,0])translate([-49,0,0])intersection(){
    raw_wing();
    rotate([90,0,0])translate([52,0,0])cylinder(h=control_surface_length-1,r=10,center=true);}
    axis();
}    

