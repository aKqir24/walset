import tomli
from sys import agrv

config: dict = {

    # Settings
    "Settings": {
        "reset": ,
        "reload": ,
        "verbose": ,
        "debug":
    },

    # Setup
    "Setup": {
        "mode": ,
        "accent_color":
    },

	# Wallpaper
    "Wallpaper": {
        "animated": ,
        "cycle": ,
	    "backend":
    }

    # Pywal
    "Pywal": {
        "backend": ,
        "light_theme": ,
        "colorscheme":
    }
}
        # TODO: "install_gtk_theme": ,
        # TODO: "install_icon_theme":,
def verify_config():
    verbose(info, "Verifying configuration file")
	if [[ ! -e "$WALLPAPER_CONF_PATH" ]]; then
		if touch "$WALLPAPER_CONF_PATH"
			verbose(error "Config file does not exist!!")
	fi
	if [[ ! -s "$WALLPAPER_CONF_PATH" ]]; then
		verbose error "Config file is empty, try modifying it!!"
	fi
def assign_config():
    tables=('Settings' 'Setup' 'Wallpaper' 'Pywal')
    with open(WALLPAPER_CONF_PATH, 'rb') as config_file:
        data = tomli.load(config_file)
        for section in tables:
            match section:
			    case f"{tables[0]}" keys=("reset", "reload", "verbose", "debug")
			    case f"{tables[1]}" keys=("theme_mode", "theme_accent_color")
			    case f"{tables[3]}" keys=("wallpaper", "cycle", "backend")
			    case f"{tables[4]}" keys=("backend", "light_theme", "colorscheme")
            for key in keys:
                if (value := data[section][key]) != "":
                    config[section][key] = value

def save_config():
