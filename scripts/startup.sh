#!/bin/sh

# Check for the following paths
if [[ ! -d $PYWAL_CACHE_DIR ]]; then
	mkdir -p "$PYWAL_CACHE_DIR"
fi

# Check PYWAL_OUT_DIR for temp folder
if [[ ! -d $PYWAL_TEMPLATES ]]; then
	mkdir -p "$PYWAL_TEMPLATES"
fi

# Check if some features are already present
INSTALLED_TAG='(installed)'
if [ -f $USER_ICONS_FOLDER"/index.theme" ]; then ICON_INS_TAG="$INSTALLED_TAG"; else unset ICON_INS_TAG; fi
if [ -f $USER_THEME_FOLDER"/index.theme" ]; then GTK_INS_TAG="$INSTALLED_TAG"; else unset GTK_INS_TAG; fi

# Check for required dependencies and figure out program the mode
command -v wal > "$LOG_FILEPATH" || verbose error "pywal16 is not installed, Please install it!"
if ! $SETUP && ! $GUI; then
    verbose info "Using walset in CLI mode!!"
    return 0
fi

if $SETUP; then
    command -v kdialog >> "$LOG_FILEPATH" 2>&1 \
        && verbose info "Using walset in SETUP (deprecated) dialog mode!!" \
        || verbose error "kdialog is not installed. Please install it!"
fi

if $GUI; then
    command -v python3 >> "$LOG_FILEPATH" 2>&1 \
        || verbose error "python3 is not installed. Please install it!"

    command -v python3-gi >> "$LOG_FILEPATH" 2>&1 \
        || verbose error "python3-gi is not installed. Please install it!"

    verbose info "Using walset in GUI mode!!"
fi

# We check if the MODE (the second argument after --theme) is "remove"
if [[ "$MODE" == "remove" ]]; then
    verbose info "Removing GTK and Icon themes..."
    theming_gtk=false
    theming_icons=false
    # Optionally clear the config variables so they don't persist
    GTK_THEME=""
    ICONS_THEME=""

# If MODE is not remove, check if the user actually provided theme names
elif [[ -n "$GTK_THEME" ]] && [[ -n "$ICONS_THEME" ]]; then
    verbose info "Setting themes to: $GTK_THEME and $ICONS_THEME"
    theming_gtk=true
    theming_icons=true
else
    # Check if previously installed via config tags
    [[ ! -z "$GTK_INS_TAG" ]] && theming_gtk=true
    [[ ! -z "$ICON_INS_TAG" ]] && theming_icons=true
    
    # If the user called --theme but didn't provide enough arguments or 'remove'
    if [[ "$1" == "--theme" ]] && [[ -z "$GTK_THEME" ]]; then
        verbose error "Usage: --theme [remove | {theme_name} {icon_name}]"
        exit 1
    fi
fi

# Debug option logic
if [[ "$DEBUG" == true ]]; then
    tail -F "$LOG_FILEPATH" &
    TAIL_PID=$!
fi
