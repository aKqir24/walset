from .paths import *
from . import messages
from os import makedirs, path

# Check for the following paths
for PYWAL_PATHS in [PYWAL_CACHE_DIR, PYWAL_TEMPLATES, path.dirname(WALLPAPER_CONF_PATH)]:
    if not path.isdir(PYWAL_PATHS):
	    makedirs(PYWAL_PATHS, exist_ok=True)

# Check if some features are already present
INSTALL_STATUS = { "ICON": False, "THEME": False }
if f"{USER_ICONS_FOLDER}/index.theme": INSTALL_STATUS['ICON'] = True
if f"{USER_THEME_FOLDER}/index.theme": INSTALL_STATUS['THEME'] = True

# TODO: Debugger & Logging
