#!/bin/bash

# To clean the theme folder when option = false
clean_path() { [[ -e $1 ]] && rm -r "$1" ; }

# Remove pywal generated files
remove_files() {
	verbose info "Reset pywal generated files..."
	PATHS_TO_REMOVE=(
		"$DEFAULT_PYWAL16_OUT_DIR" "$PYWAL_CACHE_DIR"
		"$USER_THEME_FOLDER" "$USER_ICONS_FOLDER")

	for FILE_PATH in "${PATHS_TO_REMOVE[@]}"; do
		clean_path "$FILE_PATH"
	done
}

remove_files
. "$SCRIPT_PATH/startup.sh"
