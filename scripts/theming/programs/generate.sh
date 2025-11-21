#!/bin/sh

# Functions to display error or info and quit
process() { verbose info "$2 colorsceme is applied!" ;}
die() { verbose error "$2 colorsceme cannot be processed!" ;}
write_toml() {
    local filter="$1"
    local file="${2/#\~/$HOME}"   # replace leading ~ with $HOME
    tomlq -i -t "$filter" "$file" >/dev/null || die "$file"
}


# Compare the options and run the scripts
PROGRAM="$2" ; CONFIG_DIR="$(echo "$theming_programs" | jq -r ".\"$PROGRAM\"")"
case "$PROGRAM" in
	"alacritty") PROGRAMS_CAT=0 ;;
	"dunst") PROGRAMS_CAT=1 ;;
	"i3status_rust") PROGRAMS_CAT=2 ;;
	"rofi") PROGRAMS_CAT=3 ;;
	*) PROGRAMS_CAT=4 ;;
esac

# Process status
process "$PROGRAM"

# Write the colorsceme in the toml file by calling a another script
if [ -f "$CONFIG_DIR" ] || [ "$CONFIG_DIR" = "default" ]; then
	[ "$1" = "write" ] && . "${PROGRAMS_DIR["$PROGRAMS_CAT"]}/$PROGRAM.sh" "$CONFIG_DIR" 
	if [ "$1" = "template" ]; then
		cp "$THEMING_ASSETS/programs/$PROGRAM" "$PYWAL_TEMPLATES/" 
		source "${PROGRAMS_DIR["$PROGRAMS_CAT"]}/$PROGRAM.sh" "$CONFIG_DIR"
	fi
else
	verbose sorry "Missing config folder for $2; color scheme skipped!!"
fi
