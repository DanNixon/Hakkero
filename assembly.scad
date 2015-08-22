material_thickness = 3;
height = 50;

led_positions = [15, 35];


module Top()
{
	color("Brown")
		linear_extrude(height=material_thickness, center=true)
			difference()
			{
				import (file="front.dxf", layer="cut");
				import (file="front.dxf", layer="cut_brackets");
			}
}

module TopPewter()
{
	color("Silver")
		linear_extrude(height=material_thickness, center=true)
			import (file="front_pewter.dxf", layer="cut");
}

module TopAcrylic()
{
	color("Cyan", 0.5)
		linear_extrude(height=material_thickness, center=true)
			import (file="front_acrylic.dxf", layer="cut");
}

module Side(dist)
{
	color("Red")
		rotate([90, 0, 0])
			translate([0, 0, dist])
				linear_extrude(height=material_thickness, center=true)
					import (file="side.dxf", layer="cut");
}

module Bottom()
{
	color("Brown")
		linear_extrude(height=material_thickness, center=true)
			difference()
			{
				import (file="rear.dxf", layer="cut");
				import (file="rear.dxf", layer="cut_brackets");
			}
}

module Reflector(inner, outer)
{
	color("Silver")
		hull()
		{
			translate([0, 0, height])
				cylinder(r=inner/2, h=0.01);
			cylinder(r=outer/2, h=0.01);
		}
}

module LEDRing(led_outer=140, led_width=5, led_thickness=3)
{
	color("White")
		difference()
		{
			cylinder(r=led_outer/2, h=led_width);
				translate([0, 0, -0.1])
			cylinder(r=(led_outer-led_thickness)/2, h=led_width+0.2);
		}
}


explode = 1;
side_explode = 1;


Bottom();

translate([0, 0, explode*(material_thickness/2)])
	Reflector(35, 130);

for(i = led_positions)
	translate([0, 0, explode*i])
		LEDRing();

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