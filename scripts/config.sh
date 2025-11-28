#!/bin/bash

# Default options config values
GUI=false
LOAD=false
RESET=false
SETUP=false
VERBOSE=false
THEMING_GTK=true
THEME_MODE="dark"
THEMING_ICONS=true
PYWAL_BACKEND="wal"
THEME_ACCENT_COLOR=2
WALLPAPER_CYCLE="static"
ANIMATED_WALLPAPER=false
THEMED_PROGRAMS=( 'i3status_rust' 'alacritty' 'rofi' 'dunst' )

# Write config file
verifyingCONF() {
	verbose info "Verifying the config file"
	if [[ ! -e "$WALLPAPER_CONF_PATH" ]]; then
		touch "$WALLPAPER_CONF_PATH" || \
			verbose error "Config file does not exist!!"
		[[ "$(cat "$WALLPAPER_CONF_PATH")" == "" ]] || \
			verbose error "Config file is empty, try modifing it!!"
		cat #WALLPAPER_CONF_PATH
	fi
}

# Read the config
assignTEMPCONF() {
	verbose info "Reading config file"
	tables=('wallpaper' 'theming' 'pywal16')
	JSON_TOML_OUTPUT=$( tomlq '.' "$WALLPAPER_CONF_PATH" )
	reader() { jq -r ".$1" <<< "$JSON_TOML_OUTPUT" ; }
	for section in "${tables[@]}"; do
		case $section in
			"${tables[0]}") keys=( "cycle" "type" "path" "mode" "animated" ) ;;
			"${tables[1]}") keys=( "gtk" "icons" "mode" "accent" "programs" ) ;;
			"${tables[2]}") keys=( "backend" "light" "colorscheme" ) ;;
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
		.theming.gtk = $THEMING_GTK |
		.theming.icons = $THEMING_ICONS |
		.theming.mode = \"$THEME_MODE\" |
		.theming.accent = \"$THEME_ACCENT_COLOR\" |
		.pywal16.backend = \"$PYWAL_BACKEND\" |
		.pywal16.light = $PYWAL_LIGHT |
		.pywal16.colorscheme = \"$PYWAL_COLORSCHEME\"" \
			"$WALLPAPER_CONF_PATH"
}
