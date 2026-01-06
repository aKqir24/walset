#!/bin/bash

# Copy the base theme directory in .themes
[[ -d $USER_THEME_FOLDER ]] || mkdir -p "$USER_THEME_FOLDER"
find "$BASE_THEME_FOLDER" -mindepth 1 -maxdepth 1 -print0 |
while IFS= read -r -d '' themeFile; do
	FULL_THEME_FILE_DIR="$USER_THEME_FOLDER/$(basename "$themeFile")"
	[[ -e $FULL_THEME_FILE_DIR ]] && rm -r "$FULL_THEME_FILE_DIR"
	cp -r "$themeFile" "$USER_THEME_FOLDER/"
done

for gtkCSSFile in "${GTK_CSS_FILES[@]}"; do

  # File & Folder Paths
  dir_name="$(dirname "$gtkCSSFile")"
  base_name="$(basename "$dir_name")"
  base_filename="$(basename "$dir_name".base)"
  base_file="$gtkCSSFile.base"

  # Identify the css file 
  [[ $base_filename == "general.base" ]] && gtk_tmp_file="$(basename "$base_file")" || \
	  gtk_tmp_file="$base_filename"

  # Remove/Copy base to working file
  [[ -z $1 ]] && activeColor="color2" || activeColor="$1"

  # Apply colors
  sed -i "s/{active}/$activeColor/g" "$base_file"
  temp_file_path="$PYWAL_TEMPLATES/$gtk_tmp_file"
  theme_style_file="$USER_THEME_FOLDER/$base_name/$(basename "$gtkCSSFile")"
  [[ ! -e $temp_file_path ]] && ln -s "$base_file" "$temp_file_path"
  [[ ! -e $theme_style_file ]] && ln -sf "$PYWAL_CACHE_DIR/$gtk_tmp_file" "$theme_style_file"
  if [[ $XDG_SESSION_TYPE == "wayland" ]] && [[ $base_filename == "gtk-4.0.base" ]]; then
	  [[ ! -d "$WAYLAND_GTK4" ]] && mkdir -p "$WAYLAND_GTK4" 
	  ln -sf "$theme_style_file" "$WAYLAND_GTK4"
	  ln -sf "$(dirname "$theme_style_file")/assets" "$WAYLAND_GTK4"
  fi
done
