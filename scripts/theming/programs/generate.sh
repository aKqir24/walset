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
case "$PROGRAM" in
	"alacritty") PROGRAMS_CAT=0;;
	"dunst") PROGRAMS_CAT=1;;
	"i3status_rust") PROGRAMS_CAT=2;;
	"rofi") PROGRAMS_CAT=3;;
esac

# Write the colorsceme in the toml file by calling a another script
if [[ -f $CONFIG_DIR ]]; then
	PROGRAM_VERBOSE=" 		   / - $PROGRAM\n"
	. "${PROGRAMS_DIR["$PROGRAMS_CAT"]}/$PROGRAM.sh" "$CONFIG_DIR"
else
	PROGRAM_VERBOSE=" 		   x - $PROGRAM\n"
fi

applied+="$PROGRAM_VERBOSE"
