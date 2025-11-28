#!/bin/sh

# Import all the scripts
if [[ ! -e "$(pwd)/scripts" ]]; then
	WORK_PATH="$(dirname "$0")"
else
	WORK_PATH="$(pwd)"
fi
echo "$WORK_PATH"
SCRIPT_PATH="$WORK_PATH/scripts"
SCRIPT_FILES=(paths messages config startup apply)
for script in "${SCRIPT_FILES[@]}"; do . "$SCRIPT_PATH/$script.sh"; done

# Options To be used
OPTS=$(getopt -o -v --long verbose,reset,load,setup,gui,help -- "$@") ; eval set -- "$OPTS"
while true; do
	case "$1" in
		--gui) GUI=true; shift;;
		--setup) SETUP=true; shift;;
		--reset) RESET=true; shift ;;
		--verbose) VERBOSE=true; shift ;;
		--load) LOAD=true; shift;;
		--help) echo "$HELP_MESSAGE"; exit 0;;
		--) shift; break ;;
	esac
done

# GUI dialog Configuration
if $GUI && $SETUP; then
	VERBOSE=true ; verbose sorry "You can only select one of the config optios." ; exit 1
elif $SETUP; then
	. "$SCRIPT_PATH/dialogs.sh"
elif $GUI; then
	VERBOSE=true ; verbose sorry "The '--gui' option is still in development..." ; exit 1
else
	if $LOAD; then
		verbose info "Using the previously configured settings" ; assignTEMPCONF
	else
		if ! $RESET; then
			echo "$HELP_MESSAGE"
			exit 0
		fi
	fi
fi

# Import some features
$RESET && . "$SCRIPT_PATH/reset.sh"
. "$SCRIPT_PATH/wallpaper.sh" && select_wallpaper

# Only save the config when configured!
$SETUP || $GUI && saveCONFIG ; assignTEMPCONF

# Check if --color16 option is enabled
$pywal16_light && verbose info "Enabling 16 colors in pywal..."; \
	PYWAL_GENERATE_LIGHT="--cols16 $pywal16_colorscheme"

# call the pywal to get colorsheme
applyWAL "$wallpaper_path" "$pywal16_backend" "$PYWAL_GENERATE_LIGHT" "$wallpaper_cycle" || \
	$( kdialog --msgbox "Backend is not found, using default instead!!" ;
		 applyWAL "$wallpaper_path" "wal" "$PYWAL_GENERATE_LIGHT" "$wallpaper_cycle" )

# Make a wallpaper cache to expand the features in setting the wallpaper
[[ -f "$WALLPAPER_CACHE" ]] && rm "$WALLPAPER_CACHE"

# Finalize Process and making them faster by Functions
linkCONF_DIR ; setup_wallpaper && verbose info "Process finished!!"
