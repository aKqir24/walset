import tomli
from os import path
from sys import agrv

config: dict = {

    # Setup
    "Setup": {
        "mode": "dark",
        "accent_color": 2
    },

	# Wallpaper
    "Wallpaper": {
        "animated": false,
        "cycle": "iterative",
	    "backend": "xwallpaper"
    }

    # Pywal
    "Pywal": {
        "backend": "wal",
        "light_theme": True ,
        "colorscheme": "darken"
    }
}

options: dict = {
   
    # Settings
    "Settings": {
        "reset": False,
        "reload": False,
        "verbose": True,
        "debug": False
    },
    
    "Theme": {
        "install_gtk": True,
        "install_icon": True
    }
}

def verify_config():
    verbose(info, "Verifying configuration file")
	if path.exist(WALLPAPER_CONF_PATH):
		if touch "$WALLPAPER_CONF_PATH"
			verbose(error "Config file does not exist!!")
	if [[ ! -s "$WALLPAPER_CONF_PATH" ]]; then
		verbose error "Config file is empty, try modifying it!!"
def assign_config():
    with open(WALLPAPER_CONF_PATH, 'rb') as config_file:
        data = tomli.load(config_file)
        for section in config.keys():
            for key in section.keys():
                if (value := data[section][key]) != "":
                    if 
                    config[section][key] = value

def save_config():
