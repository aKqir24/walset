import tomli
from os import path

config: dict = {

    # Setup
    "Setup": {
        "mode": "dark",
        "accent_color": 2
    },

	# Wallpaper
    "Wallpaper": {
        "animated": False,
    "cycle": "iterative",
        "backend": None, # NOTE: If it is none it will try to ask pywal, mode setup will not be applied
        "type": "image",
        "mode": "fill"
    },

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
        "debug": False,
        "load": False,
        "gui": False
    },
    
    # Theme
    "Theme": {
        "install_gtk": False,
        "install_icon": False
    }
}

def verify_config():
    verbose(info, "Verifying configuration file")
    if path.is_dir(WALLPAPER_CONF_PATH):
        with open(WALLPAPER_CONF_PATH, "w") as config_file:
            verbose(info, "Generating a default config file")
            config_file.write(config)	

def assign_config():
    with open(WALLPAPER_CONF_PATH, 'rb') as config_file:
        data = tomli.load(config_file)
        for section in config.keys():
            for key in section.keys():
                if (value := data[section][key].get()) != None: 
                    config[section][key] = value

def save_config(): pass
