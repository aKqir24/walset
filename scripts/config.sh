#!/bin/bash

# Default options config values
GUI=false
LOAD=false
DEBUG=false
RESET=false
SETUP=false
RELOAD=false
VERBOSE=false
THEMING_GTK=true
THEME_MODE="dark"
THEMING_ICONS=true
PYWAL_BACKEND="wal"
THEME_ACCENT_COLOR=2
WALLPAPER_CYCLE="static"
ANIMATED_WALLPAPER=false
WALLPAPER_BACKEND="none"
THEMED_PROGRAMS=( 'i3status_rust' 'alacritty' 'rofi' 'dunst' )

# Write config file
verifyingCONF() {
	verbose info "Verifying configuration file"
	if [[ ! -e "$WALLPAPER_CONF_PATH" ]]; then
		touch "$WALLPAPER_CONF_PATH" || \
			verbose error "Config file does not exist!!"
	fi	
	if [[ ! -s "$WALLPAPER_CONF_PATH" ]]; then
		verbose error "Config file is empty, try modifying it!!"
	fi
}

# Read the config
assignTEMPCONF() {
	verbose info "Loading configuration file"
	tables=('wallpaper' 'theming' 'pywal16')
	JSON_TOML_OUTPUT=$( tomlq '.' "$WALLPAPER_CONF_PATH" )
	reader() { jq -r ".$1" <<< "$JSON_TOML_OUTPUT" ; }
	for section in "${tables[@]}"; do
		case $section in
			"${tables[0]}") keys=( "cycle" "type" "path" "mode" "animated" "backend" ) ;;
			"${tables[1]}") keys=( "gtk" "icons" "mode" "accent" "programs" ) ;;
			"${tables[2]}") keys=( "backend" "light" "colorscheme" "reload" ) ;;
		esac
		for key in "${keys[@]}"; do
			value="$(reader "$section"."$key")"
			declare -g "${section}_$key=$value"
		done
	done
}

# Save config then read it
saveCONFIG() {
	verbose info "Saving the configurations"
	tomlq -i -t "
		.wallpaper.cycle = \"$WALLPAPER_CYCLE\" |
		.wallpaper.type = \"$WALLPAPER_TYPE\" |
		.wallpaper.path = \"$WALLPAPER_PATH\" |
		.wallpaper.mode = \"$WALLPAPER_MODE\" |
		.wallpaper.animated = $ANIMATED_WALLPAPER |
		.wallpaper.backend = $ACTIVE
		.theming.gtk = $THEMING_GTK |
		.theming.icons = $THEMING_ICONS |
		.theming.mode = \"$THEME_MODE\" |
		.theming.accent = \"$THEME_ACCENT_COLOR\" |
		.pywal16.reload = \"$RELOAD\" |
		.pywal16.backend = \"$PYWAL_BACKEND\" |
		.pywal16.light = $PYWAL_LIGHT |
		.pywal16.colorscheme = \"$PYWAL_COLORSCHEME\"" \
			"$WALLPAPER_CONF_PATH"
}

check_pywal_option() {
	# 1=pywal_option_condition | 2=option_variable | 3=option_value | 4=message
	if [[ $1 == $5 ]] || [[ $1 == $6 ]]; then
		verbose info "$4"
		declare -g "$2=${3}"
	else
		unset "$2"
	fi
}

check_walset_option() {
	if [[ $1 == $2 ]]; then
		sh -c "$3"
	fi
}
