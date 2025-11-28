#!/bin/sh

# Check for required dependencies
command -v wal > /dev/null || verbose error "pywal16 is not installed, Please install it!"
if $LOAD; then
	if $SETUP && ! command -v kdialog >/dev/null; then
		verbose error "kdialog is not installed, Please install it!"
	elif $SETUP && ! command -v python3 >/dev/null; then
		verbose error "python is not installed, Please install it!"
	fi
fi

# Check for PYWAL16_OUT_DIR
if [[ -z $PYWAL_CACHE_DIR ]]; then
	verbose warning "'PYWAL_CACHE_OUT' is not set! Add it to your .bashrc or the default will be used!!"
	verbose info "Setting up output directory"
	PYWAL_CACHE_DIR="$DEFAULT_PYWAL16_OUT_DIR"
fi
if [[ ! -d $PYWAL_CACHE_DIR ]]; then
	mkdir -p "$PYWAL_CACHE_DIR"
fi

# Check for PYWAL_OUT_DIR temp folder
if [[ ! -d $PYWAL_CACHE_DIR"/templates" ]]; then
	mkdir -p "$PYWAL_CACHE_DIR/templates"
fi

# Check if some features are already present
INSTALLED_TAG='(installed)'
if [[ -f $USER_ICONS_FOLDER"/index.theme" ]]; then ICON_INS_TAG="$INSTALLED_TAG"; else unset ICON_INS_TAG; fi
if [[ -f $USER_THEME_FOLDER"/index.theme" ]]; then GTK_INS_TAG="$INSTALLED_TAG"; else unset GTK_INS_TAG; fi
