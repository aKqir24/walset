#!/bin/sh

# Check for required dependencies and figure out program the mode
command -v wal > "$LOG_FILEPATH" || verbose error "pywal16 is not installed, Please install it!"
if ! $SETUP && ! $GUI; then
    verbose info "Using walset CLI mode!!"
    return 0
fi

if $SETUP; then
    command -v kdialog >"$LOG_FILEPATH" 2>&1 \
        && verbose info "Using SETUP (deprecated) dialog mode!!" \
        || verbose error "kdialog is not installed. Please install it!"
fi

if $GUI; then
    command -v python3 >"$LOG_FILEPATH" 2>&1 \
        || verbose error "python3 is not installed. Please install it!"

    command -v python3-gi >"$LOG_FILEPATH" 2>&1 \
        || verbose error "python3-gi is not installed. Please install it!"

    verbose info "Using GUI mode!!"
fi


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
if [[ -f $USER_ICONS_FOLDER"/index.theme" ]]; then ICON_INS_TAG="$INSTALLED_TAG"; else unset ICON_INS_TAG; fi
if [[ -f $USER_THEME_FOLDER"/index.theme" ]]; then GTK_INS_TAG="$INSTALLED_TAG"; else unset GTK_INS_TAG; fi
