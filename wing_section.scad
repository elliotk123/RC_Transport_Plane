use <airfoil.scad>;
$fn=100;

/* [ Wing ]*/
Wing_Section_Length = 80;
Wing_Chord_Length = 120;

/*[Wing Hollowing]*/
Cylinder_1_Pos = [35,0,4];
Cylinder_1_Radius = 5;
Cylinder_2_Pos = [50,0,5];
Cylinder_3_Pos = [20,0,3];

/* [ Control Surface ]*/
Control_Surface_Chord_Percentage = 0.3;//[0.0:1.0]
Control_Surface_Width_Percentage = 0.7;
Control_Surface_Side_Clearance = 1;
Control_Surface_Front_Clearance = 2;
Control_Surface_Angle = 30;//[-30:30]

/* [ Axis ]*/
Axis_X_Offset = 2;
Axis_Z_Offset = 3;
Axis_Inset = 5;

module Hollow_1()
    translate(Cylinder_1_Pos)rotate([90,0,0])
    cylinder(h=Wing_Section_Length+1,r = Cylinder_1_Radius, center = true);
    
module Hollow_2()
    translate(Cylinder_2_Pos)rotate([90,0,0])
    cylinder(h=Wing_Section_Length+1,r = Cylinder_1_Radius, center = true);
    
module Hollow_3()
    translate(Cylinder_3_Pos)rotate([90,0,0])
    cylinder(h=Wing_Section_Length+1,r = Cylinder_1_Radius, center = true);



module Raw_Wing(){
    rotate([90,0,0])translate([0,0,-Wing_Section_Length/2])airfoil(p=[0.04,0.4,12],chord=Wing_Chord_Length,length=Wing_Section_Length,taper=0,sweep=0);
}

Axis_Length = Wing_Section_Length*Control_Surface_Width_Percentage + 2*Axis_Inset;
Axis_Position = [(1-Control_Surface_Chord_Percentage)*Wing_Chord_Length+Control_Surface_Front_Clearance+Axis_X_Offset,0,Axis_Z_Offset];

module Axis(){
   translate(Axis_Position)rotate([90,0,0])cylinder(h=Axis_Length,r=1,center=true); 
}

module Axis_Hole(){
    translate(Axis_Position)rotate([90,0,0])cylinder(h=Axis_Length+1,r=1.5,center=true); 
}

Cutout_Length = Control_Surface_Chord_Percentage*Wing_Chord_Length;
Cutout_Width = Control_Surface_Width_Percentage*Wing_Section_Length;

module Wing_Cutout(){
    rotate([90,0,0])translate([Wing_Chord_Length,0,0])
    cylinder(h=Cutout_Width,r=Cutout_Length,center=true);
    }

module Wing_With_Cutout(){
        difference(){
            Raw_Wing();
            Wing_Cutout();
        }
    }

module Control_Surface_Cutter() {
    rotate([90,0,0])translate([Wing_Chord_Length,0,0])
    cylinder(h=Cutout_Width-Control_Surface_Side_Clearance*2,r=Cutout_Length-Control_Surface_Front_Clearance,center=true);
    }
    
module Control_Surface() {
    intersection(){
        Control_Surface_Cutter();
        Raw_Wing();
        }
    }
    
module Control_Surface_Rotated() {
    translate(Axis_Position)rotate([0,Control_Surface_Angle])translate(-1*Axis_Position)Control_Surface();
    }
    
difference(){
    Wing_With_Cutout();
    Axis_Hole();
    Hollow_1();
    Hollow_2();
    Hollow_3();
}
union(){
    Control_Surface_Rotated();
    Axis();
}
//difference(){difference(){
//    Raw_Wing();
//    rotate([90,0,0])translate([100,0,0])cylinder(h=control_surface_length,r=10,center=true);}
//    axis_hole();
//}
//union(){translate([49,0,0])rotate([0,control_surface_angle,0])translate([-49,0,0])intersection(){
//    raw_wing();
//    rotate([90,0,0])translate([52,0,0])cylinder(h=control_surface_length-1,r=10,center=true);}
//    axis();
//}    

