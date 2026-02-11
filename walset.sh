#!/bin/bash

# Options To be used
OPTS=$(getopt -o VRDLrh --long gui,setup,theme:,reset,debug,verbose,load,reload,help -- "$@")
if [ $? -ne 0 ]; then exit 1; fi
eval set -- "$OPTS"

while true; do
    case "$1" in
        --gui) GUI=true; shift;;
        --setup) SETUP=true; shift;;
        --theme) 
            MODE=$2 ; GTK_THEME=$3 ; ICONS_THEME=$4
            shift 4 ;; # Shift the flag + 3 arguments
        -R | --reset) RESET=true; shift ;;
        -D | --debug) DEBUG=true; shift ;;
        -V | --verbose) VERBOSE=true; shift ;;
        -L | --load) LOAD=true; shift;;
        -r | --reload) RELOAD=true; shift;;
        -h | --help) HELP_MESSAGE=true; shift;;
        --) shift; break ;;
        *) break ;;
    esac
done

# Import all the scripts
# Logical fix: simpler pathing
WORK_PATH="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$WORK_PATH/scripts"

SCRIPT_FILES=(messages paths config startup apply)
for script in "${SCRIPT_FILES[@]}"; do 
    if [[ -f "$SCRIPT_PATH/$script.sh" ]]; then
        . "$SCRIPT_PATH/$script.sh"
    fi
done

# GUI dialog Configuration
if [[ "$GUI" == true ]] || [[ "$SETUP" == true ]]; then
    VERBOSE=true ; verbose sorry "You can only select one of the config options." ; exit 1
elif [[ "$SETUP" == true ]]; then
    [[ -f "$SCRIPT_PATH/dialogs.sh" ]] && . "$SCRIPT_PATH/dialogs.sh"
elif [[ "$GUI" == true ]]; then
    VERBOSE=true ; verbose sorry "The '--gui' option is still in development..." ; exit 1
else
    if [[ "$LOAD" == true ]]; then
        verbose info "Using the previously configured settings" 
        verifyingCONF ; assignTEMPCONF
	elif [[ "$RESET" != true ]] || [[ "HELP_MESSAGE" == true ]]; then
		show_help
    fi
fi

# Only save the config when configured!
if [[ "$SETUP" == true ]] || [[ "$GUI" == true ]]; then
    verifyingCONF ; saveCONFIG ; assignTEMPCONF
fi

# Import reset feature if true
[[ "$RESET" == true ]] && [[ -f "$SCRIPT_PATH/reset.sh" ]] && . "$SCRIPT_PATH/reset.sh"

if [[ "$wallpaper_type" != "none" ]]; then
    if [[ -f "$SCRIPT_PATH/wallpaper.sh" ]]; then
        . "$SCRIPT_PATH/wallpaper.sh" && select_wallpaper
    fi
fi

# Check pywal options
check_pywal_option "$pywal16_light" "PYWAL_GENERATE_LIGHT" \
    "--cols16 $pywal16_colorscheme" "Enabling 16-color support in pywal" true
check_pywal_option "$wallpaper_cycle" "WALLPAPER_CYCLE_MODE" \
    "--$wallpaper_cycle" "Determining wallpaper change cycle" "iterative" "recursive"
check_pywal_option "$theming_mode" "LIGHT_COLORS" \
    "-l" "Enabling Generate light colors..." "light"
check_pywal_option "$RELOAD" "PYWAL_RELOAD" \
    "-e" "Skip Reloading gtk|icons|wm|programs" false

# Call pywal
applyWAL "$wallpaper_path" "$pywal16_backend" \
    "$PYWAL_GENERATE_LIGHT" "$WALLPAPER_CYCLE_MODE" "$LIGHT_COLORS" "$PYWAL_RELOAD"

# Cache cleanup
[[ -f "$WALLPAPER_CACHE" ]] && rm "$WALLPAPER_CACHE"

# Finalize
linkCONF_DIR ; [[ "$wallpaper_type" != "none" ]] && setup_wallpaper

# Cleanup debugger
[[ -n "$TAIL_PID" ]] && kill "$TAIL_PID" 2>/dev/null

verbose info "Process finished!!"
exit 0
