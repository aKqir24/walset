#!/bin/sh

# Functions to display error or info and quit
process() { verbose "$1 colorsceme is applied!" ;}
die() { verbose "$1 colorsceme cannot be processed!" >&2; exit 1 ;}
write_toml() {
    local filter="$1"
    local file="${2/#\~/$HOME}"   # replace leading ~ with $HOME
    tomlq -i -t "$filter" "$file" >/dev/null || die "$file"
}


# Compare the options and run the scripts
PROGRAM="$1" ; CONFIG_DIR="$(echo "$theming_programs" | jq -r ".\"$PROGRAM\"")"
case "$PROGRAM" in
	"alacritty") PROGRAMS_CAT=0 ; process "$PROGRAM" ;;
	"dunst") PROGRAMS_CAT=1 ; process "$PROGRAM" ;;
	"i3status_rust") PROGRAMS_CAT=2 ; process "$PROGRAM" ;;
	"rofi") PROGRAMS_CAT=3 ; process "$PROGRAM" ;;
esac

# Write the colorsceme in the toml file by calling a another script
if [ -f "$CONFIG_DIR" ]; then
	. "${PROGRAMS_DIR["$PROGRAMS_CAT"]}/$PROGRAM.sh" "$CONFIG_DIR"
fi
