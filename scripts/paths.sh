#!/bin/bash

# DEFAULT PATHS FOR CONFIG:
THEMING_ASSETS="$WORK_PATH/assets"
DEFAULT_PYWAL16_OUT_DIR="$HOME/.cache/wal"
WALLPAPER_CONF_PATH="$HOME/.config/walset.toml"
XSETTINGSD_CONF="$HOME/.xsettingsd.conf"

# Setup the output paths during pywal's export
if [[ -z $PYWAL_CACHE_DIR ]]; then
	verbose warning "'PYWAL_CACHE_OUT' is not set! Add it to your .bashrc or the default will be used!!"
	verbose info "Setting up output directory"
	PYWAL_CACHE_DIR="$DEFAULT_PYWAL16_OUT_DIR"
fi
WALLPAPER_CACHE="/tmp/wallpaper.png"
PYWAL_TEMPLATES="$PYWAL_CACHE_DIR/templates"

# ARRAY OF THE PATHS TO PROGRAMS SCRIPTS
for program in "terminal" "notification" "status" "launcher"; do
	PROGRAMS_DIR+=("$SCRIPT_PATH/theming/programs/$program")
done

# Figure xsettingsd config path
if [[ ! -f $XSETTINGSD_CONF ]]; then
	XSETTINGSD_CONF="$HOME/.config/xsettingsd/xsettingsd.conf"
fi

# GTK THEMING PATHS
WAYLAND_GTK4="$HOME/.config/gtk-4.0"
USER_THEME_FOLDER="$HOME/.themes/pywal" # revert to old path for gtk2 support
GTK_WORK_DIR="$THEMING_ASSETS/gtk"
BASE_THEME_FOLDER="$GTK_WORK_DIR/base"
for gtk_file in \
	"gtk-2.0/gtkrc" "gtk-3.0/gtk.css" "gtk-3.20/gtk.css" \
	"gtk-4.0/gtk.css" "general/dark.css"; do
	GTK_CSS_FILES+=("$BASE_THEME_FOLDER/$gtk_file")
done

# GTK ICONS PATHS
ICONS_WORK_DIR="$THEMING_ASSETS/icons"
USER_ICONS_FOLDER="$HOME/.local/share/icons/pywal"
USER_MAIN_ICONS="$USER_ICONS_FOLDER/places/scalable"
BASE_PLACES_ICONS="$ICONS_WORK_DIR/base/main/places/scalable"
BASE_FOLDER_ICONS="$ICONS_WORK_DIR/base/templates/places/scalable/folders"
