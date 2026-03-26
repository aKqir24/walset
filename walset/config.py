import tomli
import tomli_w
from os import path

from .paths import *
from .messages import logging, CommonMSG

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
        "backend": "default", # NOTE: If it is none it will try to ask pywal, mode setup will not be applied
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
        "gui": False,
        "help": False
    },
    
    # Theme
    "Theme": {
        "install_gtk": False,
        "install_icon": False
    }
}

def open_config(mode, callback):
    with open(WALLPAPER_CONF_PATH, mode) as config_file:
        callback(config_file)


def save_config():
    def handler(config_file):
        tomli_w.dump(config, config_file)

    open_config('wb', handler)


def assign_config():
    def handler(config_file):
        try:
            data = tomli.load(config_file)

            for section, values in config.items():
                for key in values.keys():
                    value = data.get(section, {}).get(key)
                    if value is not None:
                        config[section][key] = value

        except tomli.TOMLDecodeError:
            check_config()
            answer = input('Do you want to generate a default config file? [Y/n]: ')
            if answer.lower() == "y":
                save_config()
            else:
                CommonMSG.cancel_config()

    open_config('rb', handler)


def check_config():
    logging.info("Verifying configuration file")

    if not path.isfile(WALLPAPER_CONF_PATH):
        logging.info('Generating a default config file...')
        save_config()
    else:
        logging.info(f'Config file found: {WALLPAPER_CONF_PATH}')
