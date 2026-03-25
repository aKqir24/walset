from .config import options
import logging

# Manage Options
HELP_MESSAGE="""
Information:
'walsetup' is a wrapper for pywal16 purely in python and made by aKqir24,
to ease the configuration in pywal, also it adds more functionality in pywal16 which
are writen in the https://github.com/aKqir24/walset.

Usage: walset [OPTIONS]
  --gui: To launch a configuration GUI and apply the configurations.
  -R | --reload: enables programs to reload after running pywal, eg.(gtk|icons|wm)
  -r | --reset: To remove all set features, and set them all to default.
  -V | --verbose: To show log messages when each step of the script is executed.
  -h | --help: to show how to use this script, (this is ignored sometimes ignored).
  -L | --load: loads/applies the configurations."""

# Functions than is defined to handle disagreements, errors, and info's
def verbose(message, type='info'):
	match str(type):
		case "warning": logging.warning(message)
		case "error": logging.error(message)
		case "info": logging.info(message)

class Messages:
    set_wallpaper_failure = lambda: verbose("Failed to set wallpaper...", 'error')
    no_wallpaper_setter = lambda: verbose("No Wallpaper setter found!\nSo wallpaper is not set...", 'warning')
    pywal_error= lambda: verbose("Pywal16 ran into an error!\nRunning 'walset --reset --load --verbose' might fix this!", 'error')
    cancel_config = lambda: verbose("Configuration Dialog was canceled!, it might cause some problems when loading the configuration!", 'warning')
