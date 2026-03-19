from os import getenv, path
from tempfile import gettempdir

# GET ENVIRONMENT PATHS
TEMP= gettempdir()
HOME=getenv('HOME') or getenv('USERPROFILE')
PYWAL_CACHE_DIR=getenv('PYWAL_CACHE_DIR')

# DEFAULT PATHS FROM CONFIG:
LOG_FILEPATH=f"{TEMP}/walset.log"
THEMING_ASSETS=f"{HOME}/.local/share/walset/assets"
DEFAULT_PYWAL16_OUT_DIR=f"{HOME}/.cache/wal"
WALLPAPER_CONF_PATH=f"{HOME}/.config/walset/config.toml"
XSETTINGSD_CONF=f"{HOME}/.xsettingsd.conf"

# Setup the output paths during pywal's export
if not PYWAL_CACHE_DIR:
	verbose warning "'PYWAL_CACHE_OUT' is not set! Add it to your .bashrc or the default will be used!!"
	PYWAL_CACHE_DIR=DEFAULT_PYWAL16_OUT_DIR
WALLPAPER_CACHE=f"{TEMP}wallpaper.png"
PYWAL_TEMPLATES=f"{PYWAL_CACHE_DIR}/templates"

# ARRAY OF THE PATHS TO PROGRAMS SCRIPTS
PROGRAMS_SCRIPTS=(f"{PROGRAMS_SCRIPT_FOLDER}/terminal",
                  f"{PROGRAMS_SCRIPT_FOLDER}/notification",
                  f"{PROGRAMS_SCRIPT_FOLDER}/status",
                  f"{PROGRAMS_SCRIPT_FOLDER}/launcher")

# Figure xsettingsd config path
if not path.isfile(XSETTINGSD_CONF): 
    XSETTINGSD_CONF=f"{HOME}/.config/xsettingsd/xsettingsd.conf"

# GTK THEMING PATHS
WAYLAND_GTK4=f"{HOME}/.config/gtk-4.0"
USER_THEME_FOLDER=f"{HOME}/.themes/pywal" # revert to old path for gtk2 support
BASE_THEME_FOLDER=f"{THEMING_ASSETS}/gtk"
GTK_CSS_FILES=(f"{BASE_THEME_FOLDER}/gtk-2.0/gtkrc",
               f"{BASE_THEME_FOLDER}/gtk-3.0/gtk.css",
               f"{BASE_THEME_FOLDER}/gtk-3.20/gtk.css",
	           f"{BASE_THEME_FOLDER}/gtk-4.0/gtk.css",
               f"{BASE_THEME_FOLDER}/general/dark.css")

# GTK ICONS PATHS
ICONS_WORK_DIR=f"{THEMING_ASSETS}/icons"
USER_ICONS_FOLDER="{HOME}/.local/share/icons/pywal"
USER_MAIN_ICONS="$USER_ICONS_FOLDER/places/scalable"
BASE_PLACES_ICONS="$ICONS_WORK_DIR/main/places/scalable"
BASE_FOLDER_ICONS="$ICONS_WORK_DIR/templates/places/scalable/folders"
