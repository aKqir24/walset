#!/bin/sh

# Manage Options
HELP_MESSAGE="
Information:
'walsetup.sh' is a wrapper for pywal16 purely in shell script and made by aKqir24,
to ease the configuration in pywal, also it adds more functionality in pywal16 which
are writen in the https://github.com/aKqir24/walset.

Usage: $0 [OPTIONS]
  --gui: To launch a configuration GUI and apply the configurations.
  --setup: Show dialogs that sets up the configurations in order.
  --theme [add, remove]: a gtk or/and icon theme template for pywal16.
  -D | --debug: shows all the messages of this script.
  -R | --reload: enables programs to reload after running pywal, eg.(gtk|icons|wm)
  -r | --reset: To remove all set features, and set them all to default.
  -V | --verbose: To show log messages when each step of the script is executed.
  -h | --help: to show how to use this script.
  -L | --load: loads/applies the configurations.
"
applied=()

# Functions than is defined to handle disagreements, errors, and info's
verbose() {
	if $VERBOSE; then
		message="\033[1;97m$2\033[1;97m"
		case "$1" in
		"sorry")
			echo -e "walsetup \033[1;33m[WARNING]: $message";;
		"error")
			echo -e "walsetup \033[1;31m[ERROR]: $message" ;;
		"info")
			echo -e "walsetup \033[1;34m[INFO]: $message";;
		esac
		if ! $VERBOSE && ! $SETUP && ! $GUI && [ "$1" != 'info' ]; then
			kdialog "--$1" "There was a '$1' message found in the program.\n
			Please consider running this script in your terminal using the '--verbose' option, to the identify the problem!!"
		fi
		[[ $1 == "error" ]] && exit 1
	fi
}
	
wallsetERROR() { verbose error "Failed to set wallpaper..."; exit 1; }
pywalerror() { verbose error "Pywal16 ran into an error!\nplease run 'bash $0 --reset --load --verbose'" ; exit 1 ; }
wallSETTERError() { verbose warning "No Wallpaper setter found!\nSo wallpaper is not set..."; }
cancelCONFIG() { verbose warning "Configuration Dialog was canceled!, it might cause some problems when loading the configuration!"; exit 0; }
