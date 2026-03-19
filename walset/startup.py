import messages
from paths import *
from os import makedirs

# Check for the following paths
for PYWAL_PATHS in [PYWAL_CACHE_DIR, PYWAL_TEMPLATES]
    if not path.is_dir(PYWAL_PATHS):
	    makedirs(PYWAL_PATHS, exist_ok=True)

# Check if some features are already present
INSTALL_STATUS = { "ICON": False, "THEME": False }
if f"{USER_ICONS_FOLDER}/index.theme": INSTALL_STATUS['ICON'] = True
if f"{USER_THEME_FOLDER}/index.theme": INSTALL_STATUS['THEME'] = True

# TODO: Debugger & Logging
