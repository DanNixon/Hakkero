use <hakkero.scad>;
include <dimension.scad>;


explode = 1;
side_explode = 1;


/* Bottom panel */
color("Brown")
    Bottom(material_thickness);

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

/* Side panels */
color("Red")
    translate([0, 0, explode*((height+material_thickness)/2)])
        for(i = [0:7])
            rotate([0, 0, i * (360 / 8)])
                Side(material_thickness, side_explode*75);

/* Top frosted acrylic */
color("Cyan", 0.5)
    translate([0, 0, explode*height])
        TopAcrylic(material_thickness);

/* Top panel and pewter */
translate([0, 0, explode*(height+material_thickness)])
    Top(material_thickness);
