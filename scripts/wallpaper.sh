#!/bin/bash

# Wallpaper selection
select_wallpaper() {
	verbose info "Identifying wallpaper mode!"
	if [[ -z $WALL_SELECT ]] && $SETUP; then
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
            hsetrootMode="-full"; xfceMode=5; gnomeMode="zoom"; pcmanfmMode="stretch"
			xgifwallpaperMode="NONE"
            ;;
    esac

	# Set wallpaper with mode according to the available wallpaper setter
	local WALL_SETTERS=(xgifwallpaper xwallpaper hsetroot feh nitrogen swaybg xfconf-query gnome-shell pcmanfm)
	local CH_WALLSETTER=""
	
	# Kill xgifwallpaper if running
	pidof "${WALL_SETTERS[0]}" &>/dev/null && killall "${WALL_SETTERS[0]}" &>/dev/null
	
	# Detect installed setters once
	local AVAILABLE_SETTERS=()
	for installed_wallsetter in "${WALL_SETTERS[@]}"; do
		if command -v "$installed_wallsetter" >/dev/null 2>&1; then
			AVAILABLE_SETTERS+=("$installed_wallsetter")
		fi
	done

	# Choose setter
	for wallSETTER in "${AVAILABLE_SETTERS[@]}"; do
	    if [[ "$wallpaper_animated" == true && "$wallpaper" == *.gif && "$wallSETTER" == "xgifwallpaper" ]]; then
	        CH_WALLSETTER="xgifwallpaper"
	        image_path="$image_path.gif"
	        break
	    elif [[ "$wallSETTER" != "xgifwallpaper" ]]; then
	        [[ "$wallpaper_animated" == true ]] && { ANIMATED_WALLPAPER=false; verbose sorry "Wallpaper doesn’t support animation, using static instead."; }
	        CH_WALLSETTER="$wallSETTER"
	        break
	    fi
	done	
    case "$CH_WALLSETTER" in
		"${WALL_SETTERS[0]}") nohup xgifwallpaper -s $xgifwallpaperMode "$image_path" >/dev/null 2>&1 & disown || wallsetERROR ;;
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
		*.gif) magick "$wallpaper" -coalesce -flatten "$WALLPAPER_CACHE">/dev/null
			   $wallpaper_animated && cp "$wallpaper" "$WALLPAPER_CACHE.gif";;
		*)  magick "$wallpaper" "$WALLPAPER_CACHE">/dev/null
	esac
	case "$wallpaper_type" in
		"solid") magick -size 10x10 xc:"$color8" "$WALLPAPER_CACHE"
				 set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		"image") set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		*) verbose warning "Wallpaper type is not configured, so wallpaper is not set...";;
	esac
}
