include <Suwako/DXFImport.scad>;

module Top(material_thickness)
{
    color("Brown")
        DXFImport(file="front.dxf",
                  thickness=material_thickness,
                  addition_layers=["cut"],
                  subtraction_layers=["cut_brackets", "acrylic_cut"]);

    color("Silver")
        DXFImport(file="front_pewter.dxf",
                  thickness=material_thickness,
                  addition_layers=["cut"]);

    color("Black")
        DXFImport(file="front_acrylic.dxf",
                  thickness=material_thickness,
                  addition_layers=["black"],
                  subtraction_layers=["white_inner"]);

    color("White")
    {
        DXFImport(file="front_acrylic.dxf",
                  thickness=material_thickness,
                  addition_layers=["white_outer"],
                  subtraction_layers=["black"]);
        DXFImport(file="front_acrylic.dxf",
                  thickness=material_thickness,
                  addition_layers=["white_inner"]);
    }
}

module TopAcrylic(material_thickness)
{
    DXFImport(file="acrylic_diffuser.dxf",
              thickness=material_thickness,
              addition_layers=["cut"]);
}

module Side(material_thickness, dist)
{
    rotate([90, 0, 0])
        translate([0, 0, dist])
            DXFImport(file="side.dxf",
                      thickness=material_thickness,
                      addition_layers=["cut"]);
}

module Bottom(material_thickness)
{
    DXFImport(file="rear.dxf",
              thickness=material_thickness,
              addition_layers=["cut"],
              subtraction_layers=["cut_brackets"]);
}

module LEDRing(led_outer, led_width=5, led_thickness=3)
{
    difference()
    {
        cylinder(r=led_outer/2, h=led_width);
            translate([0, 0, -0.1])
        cylinder(r=(led_outer-led_thickness)/2, h=led_width+0.2);
    }
}

module LEDMount(material_thickness, height, led_outer)
{
    rad = led_outer / 2;
    translate([0, 0, material_thickness/2])
        difference()
        {
            cylinder(r=rad, h=height-material_thickness);
            translate([0, 0, 0.05])
                cylinder(r=(led_outer-material_thickness)/2, h=height-material_thickness+0.1);
        }
        cylinder(r=rad, h=material_thickness);
}

module Reflector(inner, outer, height)
{
    hull()
    {
        translate([0, 0, height])
            cylinder(r=inner/2, h=0.01);
        cylinder(r=outer/2, h=0.01);
    }
}
