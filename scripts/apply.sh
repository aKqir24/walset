#!/bin/sh

# Function to apply wallpaper using pywal16
applyWAL() {
	[[ $4 = "static" ]] && wallCYCLE="" || wallCYCLE="--$4"
	[[ $theming_mode = "light" ]] && colorscheme="-l" || colorscheme=
	generateGTKTHEME ; generateICONSTHEME ; verbose info "Running 'pywal' to generate the colorscheme"
	wal -q "$wallCYCLE" $colorscheme --backend "$2" $3 -i "$1" -n --out-dir "$PYWAL_CACHE_DIR" || pywalerror
	[[ -f $PYWAL_CACHE_DIR/colors.sh ]] && . "${PYWAL_CACHE_DIR}/colors.sh" # Load Colors & other values to be used
	generateGTKTHEME 4 ; applyToPrograms ; reloadTHEMES &
}

# Apply gtk theme / reload gtk theme
generateGTKTHEME() {
	if $theming_gtk || $RESET; then
		if [[ -z $GTK_INS_TAG ]] && [[ $1 != 4 ]]; then
			verbose info "Preparing Gtk theme templates"
			. "$SCRIPT_PATH/theming/gtk.sh" "@$theming_accent"
			echo "gtk3"
		else
			# Used as a workaround in the syntax error in template file 'gtk-4.0.base' on line '5069-5075' in `pywal16`.
			. "$SCRIPT_PATH/theming/gtk4.sh" "{$theming_accent}"
		fi
	else
		if $theming_gtk && [[ $1 != 4 ]]; then verbose info "Gtk theme is already installed!!"; fi
		if ! $theming_gtk || $RESET; then clean_path "$USER_THEME_FOLDER"; fi
	fi
}

# Apply icon theme / reload icon theme
generateICONSTHEME() {
	if $theming_icons && [[ -z $ICON_INS_TAG ]] || $RESET; then
		verbose info "Preparing Icon theme templates" 
		. "$SCRIPT_PATH/theming/icons.sh" "$theming_mode"
	elif $theming_icons; then
		verbose info "Icon theme is already installed!!"
	else 
		clean_path "$USER_ICONS_FOLDER"
	fi
}

# Set Each Theme's Name
set_THEME() {
	if ! grep -q "^${2} \"pywal\"" "$xsettingsd_config"; then
		verbose info "Setting $1 Theme..."
		if grep -q "^${2} " "$xsettingsd_config"; then
			sed -i "s|\(${2} \)\"[^\"]*\"|\1\"pywal\"|" "$xsettingsd_config"
		else
			echo "${2} \"pywal\"" >> "$xsettingsd_config"
		fi

	fi
}

# Reload Gtk themes using xsettingsd
reloadTHEMES() {
	local default_xsettings_config="$HOME/.xsettingsd.conf"
	xsettingsd_config="$HOME/.config/xsettingsd/xsettingsd.conf"
	[[ -f $xsettingsd_config ]] || xsettingsd_config="$default_xsettings_config"
	set_THEME "Icon" "Net/IconThemeName" && set_THEME "Gtk" "Net/ThemeName"
	verbose info "Reloading Gtk & Icon themes"
	(pgrep -x xsettingsd && pkill -HUP xsettingsd)>/dev/null 2>&1
	xsettingsd --config "$xsettingsd_config" >/dev/null 2>&1
	gtk-update-icon-cache "$USER_ICONS_FOLDER/" >/dev/null 2>&1 &
}

# Still pywalfox uses 'The Default OutDir in pywal so just link them to the default'
linkCONF_DIR() {
	mkdir -p "$DEFAULT_PYWAL16_OUT_DIR"
	if [[ -d $DEFAULT_PYWAL16_OUT_DIR ]] && [[ $DEFAULT_PYWAL16_OUT_DIR != $PYWAL_CACHE_DIR ]]; then
		for outFile in "$PYWAL_CACHE_DIR"/*; do
			local filename="$(basename "$outFile")"
			if [[ ! -e "$DEFAULT_PYWAL16_OUT_DIR/$filename" ]]; then
				ln -s "$outFile" "$DEFAULT_PYWAL16_OUT_DIR/"
			fi
		done
	fi
}

# Applies the color to available programs
applyToPrograms() {
	verbose info "Attempting to apply themes to programs"
	for themed_program in "${THEMED_PROGRAMS[@]}"; do
		. "$SCRIPT_PATH/theming/programs/generate.sh" "$themed_program"
	done
	verbose info "Colorsceme is applied to: \n${applied[*]}"	
}
