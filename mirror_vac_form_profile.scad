use <hakkero.scad>;
include <dimension.scad>;

projection(cut=true)
{
    rotate([-90, 0, 0])
    {
        /* LED reflector */
        color("Silver")
            translate([0, 0, explode*(material_thickness/2)])
                Reflector(reflector_inner, reflector_outer, led_mount_height);

        /* LED mount */
        color("Green", 0.5)
            LEDMount(material_thickness, led_mount_height, led_outer);
    }
}
