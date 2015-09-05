use <hakkero.scad>;
include <dimension.scad>;


explode = 1;


/* LED reflector */
color("Silver")
    translate([0, 0, explode*(material_thickness/2)])
        Reflector(reflector_inner, reflector_outer, led_mount_height);

/* LED mount */
color("Green", 0.5)
    LEDMount(material_thickness, led_mount_height, led_outer);

/* LED rings */
color("White")
    for(i = led_positions)
        translate([0, 0, explode*i])
            LEDRing(led_outer=led_outer-material_thickness-2);
