import logging

# Manage Options
HELP_MESSAGE="""
Information:
'walsetup' is a wrapper for pywal16 purely in python and made by aKqir24,
to ease the configuration in pywal, also it adds more functionality in pywal16 which
are writen in the https://github.com/aKqir24/walset.

Usage: walset [OPTIONS]
  -h, --help |  To show how to use this script, (this is ignored sometimes ignored).
  --gui      |  To launch a configuration GUI and apply the configurations.
  --reload   |  Enables programs to reload after running pywal, eg.(gtk|icons|wm)
  --reset    |  To remove all set features, and set them all to default.
  --verbose  |  To show log messages when each step of the script is executed.
  --load     |  loads/applies the configurations."""

# Functions than is defined to handle disagreements, errors, and info's
def setup_logging():
    from sys import stdout
    logging.basicConfig(
        format=("[%(levelname)s\033[0m] " "\033[1;31m%(module)s\033[0m: " "%(message)s"),
        level=logging.INFO,
        stream=stdout,
    )
    logging.addLevelName(logging.ERROR, "\033[1;31mE")
    logging.addLevelName(logging.INFO, "\033[1;32mI")
    logging.addLevelName(logging.WARNING, "\033[1;33mW")

class CommonMSG:
    set_wallpaper_failure = lambda: logging.error("Failed to set wallpaper...")
    no_wallpaper_setter = lambda: logging.warning("No Wallpaper setter found!\nSo wallpaper is not set...")
    pywal_error= lambda: logging.info("Pywal16 ran into an error!\nRunning 'walset --reset --load --verbose' might fix this!", 'error')
    cancel_config = lambda: logging.warning("Configuration Dialog was canceled!, it might cause some problems when loading the configuration!", 'warning')
