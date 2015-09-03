include <CAD-Library/dxf_import.scad>;

material_thickness = 3;
height = 50;

led_outer = 140;
led_positions = [15, 35];


module Top()
{
    color("Brown")
        DXFImport(file="front.dxf", thickness=material_thickness, addition_layers=["cut"], subtraction_layers=["cut_brackets"]);
}

module TopPewter()
{
    color("Silver")
        DXFImport(file="front_pewter.dxf", thickness=material_thickness, addition_layers=["cut"]);
}

module TopAcrylic()
{
    color("Cyan", 0.5)
        DXFImport(file="front_acrylic.dxf", thickness=material_thickness, addition_layers=["cut"]);
}

module Side(dist)
{
    color("Red")
        rotate([90, 0, 0])
            translate([0, 0, dist])
                DXFImport(file="side.dxf", thickness=material_thickness, addition_layers=["cut"]);
}

module Bottom()
{
    color("Brown")
        DXFImport(file="rear.dxf", thickness=material_thickness, addition_layers=["cut"], subtraction_layers=["cut_brackets"]);
}

module Reflector(inner, outer, height)
{
    color("Silver")
        hull()
        {
            translate([0, 0, height])
                cylinder(r=inner/2, h=0.01);
            cylinder(r=outer/2, h=0.01);
        }
}

module LEDRing(led_outer, led_width=5, led_thickness=3)
{
    color("White")
        difference()
        {
            cylinder(r=led_outer/2, h=led_width);
                translate([0, 0, -0.1])
            cylinder(r=(led_outer-led_thickness)/2, h=led_width+0.2);
        }
}

module LEDMount(led_outer)
{
    color("Green", 0.5)
        translate([0, 0, material_thickness/2])
            difference()
            {
                cylinder(r=led_outer/2, h=height-material_thickness);
                translate([0, 0, 0.05])
                    cylinder(r=(led_outer-material_thickness)/2, h=height-material_thickness+0.1);
            }
}


explode = 1;
side_explode = 1;


Bottom();

translate([0, 0, explode*(material_thickness/2)])
    Reflector(35, 130, 45);

LEDMount(led_outer);

for(i = led_positions)
    translate([0, 0, explode*i])
        LEDRing(led_outer=led_outer-material_thickness-10);

translate([0, 0, explode*((height+material_thickness)/2)])
    for(i = [0:7])
        rotate([0, 0, i * (360 / 8)])
            Side(side_explode*75);

translate([0, 0, explode*height])
    TopAcrylic();

translate([0, 0, explode*(height+material_thickness)])
{
    Top();
    TopPewter();
}
