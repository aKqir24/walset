import sys

DEFAULT_CONFIG: dict = {
    # Settings
    "RESET": false
    "RELOAD": false
    "VERBOSE": false

    # Setup
    "THEME_MODE": "dark"
    "ANIMATED_WALLPAPER": False
    "THEME_ACCENT_COLOR": 2
    "WALLPAPER_CYCLE": "static"

    # Pywal
    "PYWAL_BACKEND": "wal"
    "THEME_ACCENT_COLOR": 2
    "PYWAL_LIGHT_THEME": True
    "WALLPAPER_BACKEND": "none"
    "PYWAL_COLORSCHEME": "light"
}

if len(sys.)
# sys.argv[0] is the script name
# sys.argv[1] is the first argument
if len(sys.argv) < 2:
    print("Usage: ./script.py <first_arg>")
    sys.exit(1)
