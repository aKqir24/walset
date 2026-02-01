from sys import exit

# Manage Options
HELP_MESSAGE="""
Information:
'walsetup' is a wrapper for pywal16 purely in shell script and made by aKqir24,
to ease the configuration in pywal, also it adds more functionality in pywal16 which
are writen in the https://github.com/aKqir24/walset.

Usage: walset [OPTIONS]
  --gui: To launch a configuration GUI and apply the configurations.
  --setup: Show dialogs that sets up the configurations in order.
  --theme [add, remove]: a gtk or/and icon theme template for pywal16.
		You can add your custom theme repo by addind the 'CUSTOM_THEME_REPO' env.
  -D | --debug: shows all the messages of this script.
  -R | --reload: enables programs to reload after running pywal, eg.(gtk|icons|wm)
  -r | --reset: To remove all set features, and set them all to default.
  -V | --verbose: To show log messages when each step of the script is executed.
  -h | --help: to show how to use this script, (this is ignored sometimes ignored).
  -L | --load: loads/applies the configurations."""

# Functions than is defined to handle disagreements, errors, and info's
def verbose(type, message):
	if VERBOSE is True:
		message=f"\033[1;97m{message}\033[1;97m"
		match str(type):
		    case "sorry": print("walsetup \033[1;33m[WARNING]: " + message)
		    case "error": print("walsetup \033[1;31m[ERROR]: " + message)
		    case "info": print("walsetup \033[1;34m[INFO]: " + message)

show_help = lambda: print(HELP_MESSAGE), exit(0)
wallsetError = lambda: verbose(error, "Failed to set wallpaper..."), exit(1)
pywalError = lambda: verbose(error, "Pywal16 ran into an error!\nplease run 'walset --reset --load --verbose'"), exit 1
wallSetterError = lambda: verbose(warning, "No Wallpaper setter found!\nSo wallpaper is not set...")
cancelCONFIG = lambda: verbose(warning, "Configuration Dialog was canceled!, it might cause some problems when loading the configuration!"), exit 0
