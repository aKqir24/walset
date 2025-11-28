#!/bin/bash

# Wallpaper selection
select_wallpaper() {
	verbose info "Identifying wallpaper mode!"
	if [[ -z $WALL_SELECT ]] && $SETUP; then
		WALL_SELECT=$( kdialog --yes-label "From Image" --no-label "From Folder" \
			       --yesno "Changing your pywal Wallpaper Selection Method?" && echo "image" || echo "folder")
		wall_select_options
	else
		[[ -d $wallpaper_path ]] && WALLPAPER_FOLDER="$wallpaper_path"
		[[ -f $wallpaper_path ]] && WALLPAPER_IMAGE="$wallpaper_path"
	fi

	# Wallpaper selection method
	if [[ -d $WALLPAPER_FOLDER ]]; then
		WALLPAPER_PATH="$WALLPAPER_FOLDER"
	elif [[ -f $WALLPAPER_IMAGE ]]; then
		WALLPAPER_PATH="$WALLPAPER_IMAGE"
	elif [[ -z $wallpaper_path ]] && [[ -e $wallpaper_path ]]; then
		verbose error "Wallpaper path is empty, cannot find input image"
    else
        WALLPAPER_PATH="$wallpaper_path"
	fi
}

# Function to apply wallpaper using various setters and mapped modes
set_wallpaper_with_mode() {
    local image_path="$1"

	# Default xgifwallpaperMode values	
	local xWallMode="zoom" ; local fehMode="fill"; local nitrogenMode="auto"; local swayMode="fill"
	local hsetrootMode="-fill"; local xfceMode=5; local gnomeMode="zoom"; local pcmanfmMode="fit"
	local xgifwallpaperMode="FILL"

    # Mode mappings
    case "$wallpaper_mode" in
        "full")
            xWallMode="maximize" fehMode="max" nitrogenMode="scaled" swayMode="fit"
            hsetrootMode="-full" xfceMode=4 gnomeMode="scaled" pcmanfmMode="stretch"
			xgifwallpaperMode="MAX"
            ;;
        "tile")
            xWallMode="tile" fehMode="tile"; nitrogenMode="tiled"; swayMode="tile"
            hsetrootMode="-tile" xfceMode=1; gnomeMode="wallpaper"; pcmanfmMode="tile"
            ;;
        "center")
            xWallMode="center"; fehMode="centered"; nitrogenMode="centered"; swayMode="center"
             hsetrootMode="-center"; xfceMode=2; gnomeMode="centered"; pcmanfmMode="center"
            ;;
        "cover")
            xWallMode="stretch"; fehMode="scale"; nitrogenMode="zoom"; swayMode="stretch"
            hsetrootMode="-full"; local xfceMode=5; gnomeMode="zoom"; pcmanfmMode="stretch"
			xgifwallpaperMode="NONE"
            ;;
    esac

	# Set wallpaper with mode according to the available wallpaper setter
	local WALL_SETTERS=( xgifwallpaper xwallpaper hsetroot feh nitrogen swaybg xfconf-query gnome-shell pcmanfm )
	pgrep -x "${WALL_SETTERS[8]}">/dev/null && pkill "${WALL_SETTERS[8]}">/dev/null 2>&1 &
	for wallSETTER in "${WALL_SETTERS[@]}"; do
		if command -v "$wallSETTER" >/dev/null; then
			if $wallpaper_animated && [[ $wallpaper == *.gif ]]; then
				local CH_WALLSETTER="${WALL_SETTERS[0]}"
				image_path="$image_path.gif" ; [[ $(wal -v 2>&1 | grep -oE '3.*') = '3.8.11' ]] && \
					verbose sorry "Animated GIF wallpapers may not work in the latest pywal16. Please downgrade to 3.8.11!!"
				break
			elif [[ "$wallSETTER" != "${WALL_SETTERS[0]}" ]]; then
				ANIMATED_WALLPAPER=false ; $wallpaper_animated && verbose sorry "Wallpaper doesn’t support animation, using static instead."
				local CH_WALLSETTER="$wallSETTER"
				break
			fi
		fi
	done
    case "$CH_WALLSETTER" in
		"${WALL_SETTERS[0]}") $(nohup xgifwallpaper -s $xgifwallpaperMode "$image_path" >/dev/null 2>&1 & disown) || wallsetERROR ;;
		"${WALL_SETTERS[1]}") xwallpaper "--$xWallMode" "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[2]}") hsetroot "$hsetrootMode" "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[3]}") feh --bg-"$fehMode" "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[4]}") nitrogen --set-$nitrogenMode "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[5]}") swaybg -i "$image_path" --mode "$swayMode" || wallsetERROR;;
		"${WALL_SETTERS[6]}")
			if xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-style --set $xfceMode; then
				xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set "$image_path"; else wallsetERROR; fi
		;;
		"${WALL_SETTERS[7]}")
			if gsettings set org.gnome.desktop.background picture-uri "file://$image_path"; then
				gsettings set org.gnome.desktop.background picture-options "$gnomeMode"; else wallsetERROR; fi
		;;
		"${WALL_SETTERS[8]}") pcmanfm --set-wallpaper "$image_path" --wallpaper-mode "$pcmanfmMode" || wallsetERROR ;;
		
		*) verbose error "No supported wallpaper setter found!" return 1 ;;
	esac
}

# set the wallpaperIMAGE in display
setup_wallpaper() {
	verbose info "Changing the wallpaper"
	case "$wallpaper" in
		*.png) cp "$wallpaper" "$WALLPAPER_CACHE" ;;
		*.gif) convert "$wallpaper" -coalesce -flatten "$WALLPAPER_CACHE">/dev/null
			   $wallpaper_animated && cp "$wallpaper" "$WALLPAPER_CACHE.gif";;
		*)  convert "$wallpaper" "$WALLPAPER_CACHE">/dev/null
	esac
	case "$wallpaper_type" in
		"solid") convert -size 10x10 xc:"$color8" "$WALLPAPER_CACHE"
				 set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		"image") set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		*) verbose warning "Wallpaper type is not configured, so wallpaper is not set...";;
	esac
}
