#!/bin/sh

# Check for required dependencies
command -v wal > "$LOG_FILEPATH" || verbose error "pywal16 is not installed, Please install it!"
if $LOAD; then
	if $SETUP && ! command -v kdialog >"$LOG_FILEPATH"; then
		verbose error "kdialog is not installed, Please install it!"
	elif $SETUP && ! command -v python3 >"$LOG_FILEPATH"; then
		verbose error "python is not installed, Please install it!"
	fi
fi

# Check for the following paths
if [[ ! -d $PYWAL_CACHE_DIR ]]; then
	mkdir -p "$PYWAL_CACHE_DIR"
fi

# Check for PYWAL_OUT_DIR temp folder
if [[ ! -d $PYWAL_TEMPLATES ]]; then
	mkdir -p "$PYWAL_TEMPLATES"
fi

# Check if some features are already present
INSTALLED_TAG='(installed)'
if [[ -f $USER_ICONS_FOLDER"/index.theme" ]]; then ICON_INS_TAG="$INSTALLED_TAG"; else unset ICON_INS_TAG; fi
if [[ -f $USER_THEME_FOLDER"/index.theme" ]]; then GTK_INS_TAG="$INSTALLED_TAG"; else unset GTK_INS_TAG; fi
