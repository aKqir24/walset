#!/bin/sh

# Functions to display error or info and quit
die() { verbose error "$1 colorsceme cannot be processed!" ;}
write_toml_alt() {
    local rules="$1"
    local file="$2"

    echo "$rules" | tr '|' '\n' | while read -r line; do
        line="$(echo "$line" | xargs)"
        [ -z "$line" ] && continue

        local path="${line%%=*}"
        local value="${line#*=}"

        path="$(echo "$path" | xargs)"
        value="$(echo "$value" | xargs | sed 's/^"//;s/"$//')"

        local section="${path#*.}"
        section="${section%%.*}"
        local key="${path##*.}"

        awk -v sec="$section" -v key="$key" -v val="$value" '
        BEGIN { in_section=0 }

        /^\[/ {
            in_section = ($0 == "[" sec "]")
        }

        in_section && $1 == key {
            print key " = \"" val "\""
            next
        }

        { print }
        ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    done
}

write_toml() {
    local filter="$1"
    local file="${2/#\~/$HOME}"

    if ! tomlq -i -t "$filter" "$file" >> "$LOG_FILEPATH" 2>&1; then
        verbose sorry "skipped invalid TOML in $file"
		verbose info "Attemping to use alternative loader..."
		if ! write_toml_alt "$filter" "$file" >> "$LOG_FILEPATH" 2>&1; then 
			verbose sorry "Alternative toml writer failed!!"
		fi
    fi
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
