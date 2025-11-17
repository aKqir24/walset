#!/bin/bash

# Check for required dependencies
command -v wal > /dev/null || echo "pywal16 is not installed, Please install it!"
if $LOAD; then
	if $SETUP && ! command -v kdialog >/dev/null; then
		echo "kdialog is not installed, Please install it!" ; exit 1
	elif $SETUP && ! command -v python3 >/dev/null; then
		echo "python is not installed, Please install it!" ; exit 1
	fi
fi

# Check for PYWAL16_OUT_DIR
if [ -z "$PYWAL_CACHE_DIR" ]; then
	verbose warning "The 'PYWAL_OUT_DIR' environment variable is not defined!\nAdding it in your .bashrc file or It will the default!!"
	verbose info "Setting up output directory"
	$PYWAL_OUT_DIR=$DEFAULT_PYWAL16_OUT_DIR	
elif [ ! -d "$PYWAL_CACHE_DIR" ]; then
	mkdir -p "$PYWAL_CACHE_DIR"
fi

# Check for PYWAL_OUT_DIR temp folder
if [ ! -d "$PYWAL_CACHE_DIR/templates" ]; then
	mkdir -p $PYWAL_CACHE_DIR/templates
fi

# Check if some features are already present
INSTALLED_TAG='(installed)'
[ -f "$USER_ICONS_FOLDER/index.theme" ] && ICON_INS_TAG="$INSTALLED_TAG"
[ -f "$USER_THEME_FOLDER/index.theme" ] && GTK_INS_TAG="$INSTALLED_TAG"
