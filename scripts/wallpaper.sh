#!/bin/bash

# Wallpaper selection
select_wallpaper() {
	verbose info "Detecting wallpaper mode"
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

	# Default wallpaperMode values	
	local xWallMode="zoom" ; local fehMode="fill"; local nitrogenMode="auto"; local swayMode="fill"
	local hsetrootMode="-fill"; local xfceMode=5; local gnomeMode="zoom"; local pcmanfmMode="fit"
	local xgifwallpaperMode="FILL" awwwMode="crop"

    # Mode mappings
    case "$wallpaper_mode" in
        "full")
            xWallMode="maximize" fehMode="max" nitrogenMode="scaled" swayMode="fit"
            hsetrootMode="-full" xfceMode=4 gnomeMode="scaled" pcmanfmMode="stretch"
			xgifwallpaperMode="MAX" awwwMode="fit"
            ;;
        "tile")
            xWallMode="tile" fehMode="tile"; nitrogenMode="tiled"; swayMode="tile"
            hsetrootMode="-tile" xfceMode=1; gnomeMode="wallpaper"; pcmanfmMode="tile"
			awwwMode="tile"
            ;;
        "center")
            xWallMode="center"; fehMode="centered"; nitrogenMode="centered"; swayMode="center"
             hsetrootMode="-center"; xfceMode=2; gnomeMode="centered"; pcmanfmMode="center"
			 awwwMode="crop"
            ;;
        "cover")
            xWallMode="stretch"; fehMode="scale"; nitrogenMode="zoom"; swayMode="stretch"
            hsetrootMode="-full"; xfceMode=5; gnomeMode="zoom"; pcmanfmMode="stretch"
			xgifwallpaperMode="NONE" awwwMode="stretch"
            ;;
    esac

	# Set wallpaper with mode according to the available wallpaper setters
	local WALL_SETTERS=()
	local CH_WALLSETTER=""
	local AVAILABLE_SETTERS=()
	local WALL_SETTERS_STATIC;
	local WALL_SETTERS_ANIMATED;

	if [[ ! -z $WAYLAND_DISPLAY ]]; then
		WALL_SETTERS_STATIC=(awww swaybg gnome-shell)
		WALL_SETTERS_ANIMATED=(awww)
	else
		WALL_SETTERS_STATIC=(xwallpaper hsetroot feh nitrogen xfconf-query pcmanfm gnome-shell)
		WALL_SETTERS_ANIMATED=(xgifwallpaper)
	fi
	
	# Choose setter type
	if [[ "$wallpaper_animated" == true ]]; then
		WALL_SETTERS=(${WALL_SETTERS_ANIMATED[@]})
	else
		WALL_SETTERS=(${WALL_SETTERS_STATIC[@]})
	fi

	# Detect installed setters once	
	choose_available_setter() {
		for installed_wallsetter in "${WALL_SETTERS[@]}"; do
			command -v "$installed_wallsetter" >"$LOG_FILEPATH" 2>&1 && \
				AVAILABLE_SETTERS+=("$installed_wallsetter")
		done
	}
	choose_available_setter
	if [[ "$wallpaper_animated" == true && -z "$AVAILABLE_SETTERS" ]]; then
		ANIMATED_WALLPAPER=false
		WALL_SETTERS=(${WALL_SETTERS_STATIC[@]})
		choose_available_setter
		verbose sorry "Wallpaper doesn’t support animation, using static instead."
	elif [[ "$wallpaper" == *.gif ]]; then
		image_path="$image_path.gif"
	fi	
	
	for wallSETTER in "${AVAILABLE_SETTERS[@]}"; do
		if [[ $wallSETTER == $wallpaper_backend ]]; then
			CH_WALLSETTER="$wallpaper_backend"
			break
		else
			CH_WALLSETTER=$wallSETTER
			break
		fi
	done
	
	# Kill running wallpaper deamon if running
	pidof "${CH_WALLSETTER}" &>"$LOG_FILEPATH" && killall "${CH_WALLSETTER}" &>/dev/null
	
	# Use the wallpaper backend first available
    case "$CH_WALLSETTER" in
		"xgifwallpaper") nohup xgifwallpaper -s $xgifwallpaperMode "$image_path" >"$LOG_FILEPATH" 2>&1 & disown || wallsetERROR ;;
		"xwallpaper") xwallpaper "--$xWallMode" "$image_path" || wallsetERROR;;
        "hsetroot") hsetroot "$hsetrootMode" "$image_path" || wallsetERROR;;
        "feh") feh --bg-"$fehMode" "$image_path" || wallsetERROR;;
        "nitrogen") nitrogen --set-$nitrogenMode "$image_path" || wallsetERROR;;
		"swaybg") swaybg -i "$image_path" --mode "$swayMode" >"$LOG_FILEPATH" 2>&1 & disown || wallsetERROR;;
		"awww")
			pidof "${CH_WALLSETTER}-deamon" &>"$LOG_FILEPATH" || "${CH_WALLSETTER}-deamon" &>"$LOG_FILEPATH"
			awww img "$image_path" --resize "$awwwMode" >"$LOG_FILEPATH" 2>&1 & disown || wallsetERROR
			;;
		"xfconf-query")
			if xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-style --set $xfceMode; then
				xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set "$image_path"; else wallsetERROR; fi
		;;
		"gnome-shell")
			if gsettings set org.gnome.desktop.background picture-uri "file://$image_path"; then
				gsettings set org.gnome.desktop.background picture-options "$gnomeMode"; else wallsetERROR; fi
		;;
		"pcmanfm") pcmanfm --set-wallpaper "$image_path" --wallpaper-mode "$pcmanfmMode" || wallsetERROR ;;	
		*) verbose error "No supported wallpaper setter found!" return 1 ;;
	esac
}

# set the wallpaperIMAGE in display
setup_wallpaper() {
	verbose info "Changing the wallpaper"
	case "$wallpaper" in
		*.png) cp "$wallpaper" "$WALLPAPER_CACHE" ;;
		*.gif) magick "$wallpaper" -coalesce -flatten "$WALLPAPER_CACHE">"$LOG_FILEPATH"
			   $wallpaper_animated && cp "$wallpaper" "$WALLPAPER_CACHE.gif";;
		*)  magick "$wallpaper" "$WALLPAPER_CACHE">"$LOG_FILEPATH"
	esac
	case "$wallpaper_type" in
		"solid") magick -size 10x10 xc:"$color8" "$WALLPAPER_CACHE"
				 set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		"image") set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		*) verbose warning "Wallpaper type is not configured, so wallpaper is not set...";;
	esac
}
