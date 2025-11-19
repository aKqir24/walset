#!/bin/sh

# Function to apply wallpaper using pywal16
applyWAL() {
	[ "$4" = "static" ] && wallCYCLE="" || wallCYCLE="--$4"
	[ "$theming_mode" = "light" ] && colorscheme="-l" || colorscheme=
	generateGTKTHEME ; generateICONSTHEME ; verbose info "Running 'pywal' to generate the colorscheme"
	wal -q "$wallCYCLE" $colorscheme --backend "$2" $3 -i "$1" -n --out-dir "$PYWAL_CACHE_DIR" || pywalerror
	[ -f "$PYWAL_CACHE_DIR/colors.sh" ] && . "${PYWAL_CACHE_DIR}/colors.sh" # Load Colors & other values to be used
	generateGTKTHEME 4 ; applyToPrograms ; reloadTHEMES &
}

# To clean the theme folder when option = false
clean_theme_folder() { [ -e "$1" ] && rm -r "$1" ; }

# Apply gtk theme / reload gtk theme
generateGTKTHEME() {
	if $theming_gtk && [ -z "$GTK_INS_TAG" ] || $RESET; then
		if [ "$1" != 4 ]; then
			verbose info "Preparing Gtk theme templates"
			. "$SCRIPT_PATH/theming/gtk.sh" "@$theming_accent" &
		else
			# Used as a workaround in the syntax error in template file 'gtk-4.0.base' on line '5069-5075' in `pywal16`.
			. "$SCRIPT_PATH/theming/gtk4.sh" "{$theming_accent}" &
		fi
	else
		$theming_gtk && [ "$1" != 4 ] && verbose info "Gtk theme is already installed!!" || $theming_gtk || clean_theme_folder "$USER_THEME_FOLDER"
	fi
}

# Apply icon theme / reload icon theme
generateICONSTHEME() {
	if $theming_icons && [ -z "$ICON_INS_TAG" ] || $RESET; then
		verbose info "Preparing Icon theme templates"
		[ -z "$ICON_INS_TAG" ] && . "$SCRIPT_PATH/theming/icons.sh" "$theming_mode" &
	else
		$theming_icons && verbose info "Icon theme is already installed!!" || clean_theme_folder "$USER_ICONS_FOLDER" 
	fi
}

# Set Icon Theme's Name
setGTK_THEME() {
	if ! grep -q '^Net/ThemeName "pywal"' "$xsettingsd_config"; then
		verbose info "Setting Gtk Theme..."
		if grep -q "^Net/ThemeName " "$1"; then
			sed -i 's|\(Net/ThemeName \)"[^"]*"|\1"pywal"|' "$1"
		else
			echo 'Net/ThemeName "pywal"' >> "$1"
		fi
	else
		verbose info "Gtk theme is already set"
	fi
}

setICON_THEME() {
	if ! grep -q '^Net/IconThemeName "pywal"' "$xsettingsd_config"; then
		verbose info "Setting Icon Theme..."
		if grep -q "^Net/IconThemeName " "$1"; then
			sed -i 's|\(Net/IconThemeName \)"[^"]*"|\1"pywal"|' "$1"
		else
			echo 'Net/IconThemeName "pywal"' >> "$1"
		fi
	else
		verbose info "Icon theme is already set"
	fi
}

# Reload Gtk themes using xsettingsd
reloadTHEMES() {
	local default_xsettings_config="$HOME/.xsettingsd.conf"
	local xsettingsd_config="$HOME/.config/xsettingsd/xsettingsd.conf"
	[ -f "$xsettingsd_config" ] || xsettingsd_config="$default_xsettings_config"
	setGTK_THEME "$xsettingsd_config" & setICON_THEME "$xsettingsd_config"
	verbose info "Reloading Gtk & Icon themes"
	command -v xsettingsd >/dev/null && pkill xsettingsd >/dev/null 2>&1 ;\
		xsettingsd -c "$xsettingsd_config" >/dev/null 2>&1 &
}

# Still pywalfox uses 'The Default OutDir in pywal so just link them to the default'
linkCONF_DIR() {
	if [ -d "$DEFAULT_PYWAL16_OUT_DIR" ] && [ "$DEFAULT_PYWAL16_OUT_DIR" != "$PYWAL_CACHE_DIR" ]; then
		for outFile in "$PYWAL_CACHE_DIR"/*; do
			local filename="$(basename "$outFile")"
			if [ ! -e "$DEFAULT_PYWAL16_OUT_DIR/$filename" ]; then
				ln -sf "$outFile" "$DEFAULT_PYWAL16_OUT_DIR/" >/dev/null
			fi
		done
	fi
}

# Applies the color to available programs
applyToPrograms() {
	verbose info "Attempting to apply themes to programs"
	for themed_program in ${THEMED_PROGRAMS[@]}; do
		. "$SCRIPT_PATH/theming/programs/generate.sh" "$themed_program"
	done
}
