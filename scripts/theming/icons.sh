#!/bin/bash

# Variables that contain settings & paths
BASE_ICON_PATHS=("$ICONS_WORK_DIR/base/$1" "$ICONS_WORK_DIR/base/main")

# Copy the base icons
[[ -d $USER_ICONS_FOLDER ]] || mkdir -p "$USER_ICONS_FOLDER"
for icon_path in "${BASE_ICON_PATHS[@]}"; do
	for some_icons in $icon_path/*; do
		cp -r "$some_icons" "$USER_ICONS_FOLDER/"
	done
done

# Replace the base icons with the pywal one 
[[ -e $USER_ICONS_FOLDER  ]] || mkdir -p "$USER_MAIN_ICONS"

# Link the pywal generated folder icons
for user_icon in "$BASE_FOLDER_ICONS"/*; do
	ICON_NAME="$(basename "$user_icon")" ; ICON_PATH="$USER_MAIN_ICONS/$ICON_NAME"
	[ -e "$PYWAL_TEMPLATES/$ICON_NAME" ] || ln -s "$user_icon" "$PYWAL_TEMPLATES/"
	[ -h "$ICON_PATH" ] || ln -s "$PYWAL_CACHE_DIR/$ICON_NAME" "$ICON_PATH"
done
