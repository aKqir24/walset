#!/bin/bash
# Now gtk4 has its seperate generation, If a developer is reading this, then please consider that!!
# this part part of the script is used as a workaround in the syntax error in template file 'gtk-4.0.base' on line '5069-5075' in `pywal16`.
# Removing those lines might solve the problem but I am not too sure, what do you think?
gtk4_base_file="$PYWAL_CACHE_DIR/templates/gtk-4.0.base"
gtk4_theme_file="$PYWAL_CACHE_DIR/gtk-4.0.base"

# Remove template after generation of colors
[ -f "$gtk4_theme_file" ] || ln -sf "$gtk4_base_file" "$gtk4_theme_file"

# Apply sed in-place
sed -i \
	-e "s/{color0}/$color0/g;" \
	-e "s/{color1}/$color1/g;" \
	-e "s/{color2}/$color2/g;" \
	-e "s/{color3}/$color3/g;" \
	-e "s/{color4}/$color4/g;" \
	-e "s/{color5}/$color5/g;" \
	-e "s/{color6}/$color6/g;" \
	-e "s/{color7}/$color7/g;" \
	-e "s/{color8}/$color8/g;" \
	-e "s/{color9}/$color9/g;" \
	-e "s/{color10}/$color10/g;" \
	-e "s/{color11}/$color11/g;" \
	-e "s/{color12}/$color12/g;" \
	-e "s/{color13}/$color13/g;" \
	-e "s/{color14}/$color14/g;" \
	-e "s/{color15}/$color15/g;" \
	"$gtk4_theme_file"
