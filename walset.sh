#!/bin/sh

# Import all the scripts
if [[ ! -e "$(pwd)/scripts" ]]; then
	WORK_PATH="$(dirname "$0")"
else
	WORK_PATH="$(pwd)"
fi
SCRIPT_PATH="$WORK_PATH/scripts"
SCRIPT_FILES=(messages paths config startup apply)
for script in "${SCRIPT_FILES[@]}"; do . "$SCRIPT_PATH/$script.sh"; done

# Options To be used
OPTS=$(getopt -o -v --long verbose,reset,load,reload,setup,gui,help -- "$@") ; eval set -- "$OPTS"
while true; do
	case "$1" in
		--gui) GUI=true; shift;;
		--setup) SETUP=true; shift;;
		--reset) RESET=true; shift ;;
		--verbose) VERBOSE=true; shift ;;
		--load) LOAD=true; shift;;
		--reload) RELOAD=true; shift;;
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
		verbose info "Using the previously configured settings" 
		verifyingCONF ; assignTEMPCONF
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
if $SETUP || $GUI; then
	verifyingCONF ; saveCONFIG ; assignTEMPCONF
fi

# Check pywal options if either enabled or disabled
check_pywal_option $pywal16_light "PYWAL_GENERATE_LIGHT" \
	"--cols16 $pywal16_colorscheme" "Enabling 16 colors in pywal..." true
check_pywal_option "$wallpaper_cycle" "WALLPAPER_CYCLE_MODE" \
	"--$wallpaper_cycle" "Identifying wallpaper change cycle" "iterative" "recursive"
check_pywal_option $theming_mode "LIGHT_COLORS" \
	"-l" "Enabling Generate light colors..." "light"
check_pywal_option $RELOAD "PYWAL_RELOAD" \
	"-e" "Skip Reloading gtk|icons|wm|programs" false

# call the pywal to get colorsheme
applyWAL "$wallpaper_path" "$pywal16_backend" \
	"$PYWAL_GENERATE_LIGHT" "$WALLPAPER_CYCLE_MODE" "$LIGHT_COLORS" "$PYWAL_RELOAD"

# Make a wallpaper cache to expand the features in setting the wallpaper
[[ -f "$WALLPAPER_CACHE" ]] && rm "$WALLPAPER_CACHE"

# Finalize Process and making them faster by Functions
linkCONF_DIR ; setup_wallpaper && verbose info "Process finished!!"
