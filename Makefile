out_dir = ./dxf

clean:
	rm -rf $(out_dir)

output_folder:
	mkdir -p $(out_dir)

mirror_vac_form_profile: output_folder
	openscad mirror_vac_form_profile.scad -o $(out_dir)/mirror_vac_form_profile.dxf
