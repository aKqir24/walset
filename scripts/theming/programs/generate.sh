#!/bin/sh

# Functions to display error or info and quit
die() { verbose error "$1 colorsceme cannot be processed!" ;}
write_toml() {
    local filter="$1"
    local file="${2/#\~/$HOME}"   # replace leading ~ with $HOME
    tomlq -i -t "$filter" "$file" >/dev/null || die "$file"
}


# Compare the options and run the scripts
PROGRAM="$1" ; CONFIG_DIR="$(echo "$theming_programs" | jq -r ".\"$PROGRAM\"")"
PROGRAM_VERBOSE=" 		  - $PROGRAM\n"
case "$PROGRAM" in
	"alacritty") PROGRAMS_CAT=0 ; applied+="$PROGRAM_VERBOSE" ;;
	"dunst") PROGRAMS_CAT=1 ; applied+="$PROGRAM_VERBOSE" ;;
	"i3status_rust") PROGRAMS_CAT=2 ; applied+="$PROGRAM_VERBOSE" ;;
	"rofi") PROGRAMS_CAT=3 ; applied+="$PROGRAM_VERBOSE" ;;
esac

# Write the colorsceme in the toml file by calling a another script
if [[ -f $CONFIG_DIR ]]; then
	. "${PROGRAMS_DIR["$PROGRAMS_CAT"]}/$PROGRAM.sh" "$CONFIG_DIR"
else
	verbose sorry "Missing config folder for $1; color scheme skipped!!"
fi
