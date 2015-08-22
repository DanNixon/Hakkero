height = 50;

reflector_min = 35;
reflector_max = 130;

led_outer = 140;
led_width = 5;
led_thickness = 2.5;

led_positions = [15, 35];

$fn = 128;

hull()
{
	translate([0, 0, height])
		cylinder(d=reflector_min, h=0.01);
	cylinder(d=reflector_max, h=0.01);
}

for(i = led_positions)
{
	translate([0, 0, i])
	{
		difference()
		{
			cylinder(d=led_outer, h=led_width);
				translate([0, 0, -0.1])
			cylinder(d=led_outer-led_thickness, h=led_width+0.2);
		}
	}
}