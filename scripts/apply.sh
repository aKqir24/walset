#!/bin/sh

# Function to apply wallpaper using pywal16
applyWAL() {	
	generateGTKTHEME ; generateICONSTHEME ; verbose info "Running 'pywal' to generate the colorscheme"
	echo "wal $4 $colorscheme --backend $2 $3 -i $1 -n --out-dir $PYWAL_CACHE_DIR $5"
	sh -c "wal $4 $colorscheme --backend $2 $3 -i $1 -n --out-dir $PYWAL_CACHE_DIR $5" || pywalerror
	[[ -f $PYWAL_CACHE_DIR/colors.sh ]] && . "${PYWAL_CACHE_DIR}/colors.sh" # Load Colors & other values to be used
	generateGTKTHEME 4 ; set_THEME "Icon" "Net/IconThemeName" && set_THEME "Gtk" "Net/ThemeName" ; applyToPrograms 
	if $RELOAD; then 
		reloadTHEMES
	fi
}

# Apply gtk theme / reload gtk theme
generateGTKTHEME() {
	if $theming_gtk || $RESET; then
		if [[ -z $GTK_INS_TAG ]] && [[ $1 != 4 ]]; then
			verbose info "Preparing Gtk theme templates"
			. "$SCRIPT_PATH/theming/gtk.sh" "@$theming_accent"
		else
			# Used as a workaround in the syntax error in template file 'gtk-4.0.base' on line '5069-5075' in `pywal16`.
			. "$SCRIPT_PATH/theming/gtk4.sh" "{$theming_accent}"
		fi
		if [[ $1 != 4 ]]; then verbose info "Gtk theme is already installed!!"; fi
	else
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
	if ! grep -q "^${2} \"pywal\"" "$XSETTINGSD_CONF"; then
		verbose info "Setting $1 Theme..."
		if grep -q "^${2} " "$XSETTINGSD_CONF"; then
			sed -i "s|\(${2} \)\"[^\"]*\"|\1\"pywal\"|" "$XSETTINGSD_CONF"
		else
			echo "${2} \"pywal\"" >> "$XSETTINGSD_CONF"
		fi

	fi
}

# Reload Gtk themes using xsettingsd
reloadTHEMES() {	
	verbose info "Reloading Gtk & Icon themes"
	(pgrep -x xsettingsd && pkill -HUP xsettingsd)>/dev/null 2>&1
	xsettingsd --config "$XSETTINGSD_CONF">/dev/null 2>&1
	gtk-update-icon-cache "$USER_ICONS_FOLDER/">/dev/null 2>&1 &
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
	verbose info "Program Colorscheme Status: \n${applied[*]}"	
}
