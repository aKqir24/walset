#!/bin/bash

# Import paths to managed
. "$SCRIPT_PATH/paths.sh"

# Remove pywal generated files
remove_files() {
	verbose info "Reset pywal generated files..."
	PATHS_TO_REMOVE=(
		"$DEFAULT_PYWAL16_OUT_DIR" "$PYWAL_CACHE_DIR"
		"$USER_THEME_FOLDER" "$USER_ICONS_FOLDER")
	
	for FILE_PATH in "${PATHS_TO_REMOVE[@]}"; do
		[ -e ""$FILE_PATH ] && rm -rf "$FILE_PATH"
	done
}

remove_files ; $SHELL "$SCRIPT_PATH/startup.sh" 
