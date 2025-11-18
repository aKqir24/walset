# Wallpaper selection
select_wallpaper() {
	verbose info "Identifying wallpaper mode!"
	if [ -z "$WALL_SELECT" ] && [ "$SETUP" = true ]; then
		WALL_SELECT=$( kdialog --yes-label "From Image" --no-label "From Folder" \
			       --yesno "Changing your pywal Wallpaper Selection Method?" && echo "image" || echo "folder")
		wall_select_options
	else
		[ -d "$wallpaper_path" ] && WALLPAPER_FOLDER="$wallpaper_path"
		[ -f "$wallpaper_path" ] && WALLPAPER_IMAGE="$wallpaper_path"
	fi

	# Wallpaper selection method
	if [ -d "$WALLPAPER_FOLDER" ]; then
		WALLPAPER_PATH=$WALLPAPER_FOLDER
	elif [ -f "$WALLPAPER_IMAGE" ]; then
		WALLPAPER_PATH=$WALLPAPER_IMAGE
	else
		WALLPAPER_PATH="$wallpaper_path"
	fi
}

# Function to apply wallpaper using various setters and mapped modes
set_wallpaper_with_mode() {
    local image_path="$1"
	
	# Default mode mapping values is (fill)
    local xWallMode="zoom"; local fehMode="fill"; local nitrogenMode="auto"; local swayMode="fill"
    local hsetrootMode="-fill"; local xfceMode=5; local gnomeMode="zoom"; local pcmanfmMode="fit"
	local xgifwallpaperMode="NONE"

    # Mode mappings
    case "$wallpaper_mode" in
        "fill") xgifwallpaperMode="FILL" # This the default condition no need to duplicate
            ;;
        "full")
            local xWallMode="maximize"; local fehMode="max"; local nitrogenMode="scaled"; local swayMode="fit"
            local hsetrootMode="-full"; local xfceMode=4; local gnomeMode="scaled"; local pcmanfmMode="stretch"
			local xgifwallpaperMode="MAX"
            ;;
        "tile")
            local xWallMode="tile"; local fehMode="tile"; local nitrogenMode="tiled"; local swayMode="tile"
            local hsetrootMode="-tile"; local xfceMode=1; local gnomeMode="wallpaper"; local pcmanfmMode="tile"
            ;;
        "center")
            local xWallMode="center"; local fehMode="centered"; local nitrogenMode="centered"; local swayMode="center"
            local hsetrootMode="-center"; local xfceMode=2; local gnomeMode="centered"; local pcmanfmMode="center"
            ;;
        "cover")
            local xWallMode="stretch"; local fehMode="scale"; local nitrogenMode="zoom"; local swayMode="stretch"
            local hsetrootMode="-full"; local xfceMode=5; local gnomeMode="zoom"; local pcmanfmMode="stretch"
            ;;
    esac
	
	# Set wallpaper with mode according to the available wallpaper setter
	local WALL_SETTERS=( xwallpaper hsetroot feh nitrogen swaybg xfconf-query gnome-shell pcmanfm xgifwallpaper )
	if $wallpaper_animated && [[ $wallpaper == *.gif ]] && command -v "${WALL_SETTERS[8]}" >/dev/null; then
		local CH_WALLSETTER="${WALL_SETTERS[8]}" image_path="$image_path.gif"
		verbose sorry "Animated wallpaper is only limited to gif wallpapers and small size gifs!!"
	else
		$wallpaper_animated && verbose sorry "Animated wallpaper is set to false, falling back to static image..."
		ANIMATED_WALLPAPER=false ; pgrep -x "${WALL_SETTERS[8]}">/dev/null && pkill "${WALL_SETTERS[8]}">/dev/null
		for wallSETTER in "${WALL_SETTERS[@]}"; do
			if command -v "$wallSETTER" >/dev/null && [ "$wallSETTER" != "${WALL_SETTERS[8]}" ]; then
				local CH_WALLSETTER="$wallSETTER"
				break
			fi
		done
	fi
    case "$CH_WALLSETTER" in 
		"${WALL_SETTERS[0]}") xwallpaper "--$xWallMode" "$image_path" --daemon || wallsetERROR;;
        "${WALL_SETTERS[1]}") hsetroot "$hsetrootMode" "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[2]}") feh --bg-"$fehMode" "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[3]}") nitrogen --set-$nitrogenMode "$image_path" || wallsetERROR;;
        "${WALL_SETTERS[4]}") swaybg -i "$image_path" --mode "$swayMode" || wallsetERROR;;
		"${WALL_SETTERS[5]}")
			if xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-style --set $xfceMode ;then
				xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set "$image_path"
			else
				wallsetERROR
			fi
		;;
		"${WALL_SETTERS[6]}")
			if gsettings set org.gnome.desktop.background picture-uri "file://$image_path" ;then
				gsettings set org.gnome.desktop.background picture-options "$gnomeMode" 
			else
				wallsetERROR
			fi
		;;
		"${WALL_SETTERS[7]}") pcmanfm --set-wallpaper "$image_path" --wallpaper-mode "$pcmanfmMode" || wallsetERROR ;;
		"${WALL_SETTERS[8]}") $(nohup xgifwallpaper -s $xgifwallpaperMode "$image_path" >/dev/null 2>&1 & disown) || wallsetERROR ;;
		*) verbose error "No supported wallpaper setter found!" return 1 ;;
	esac
}

# set the wallpaperIMAGE in display
setup_wallpaper() {
	verbose info "Setting the wallpaper..."
	case "$wallpaper" in
		*.png) cp "$wallpaper" "$WALLPAPER_CACHE" ;;
		*.gif) 
			convert "$wallpaper" -coalesce -flatten "$WALLPAPER_CACHE">/dev/null
			$wallpaper_animated && cp "$wallpaper" "$WALLPAPER_CACHE.gif";;
		*)  convert "$wallpaper" $WALLPAPER_CACHE>/dev/null
	esac
	case "$wallpaper_type" in
		"solid")
			convert -size 10x10 xc:"$color8" "$WALLPAPER_CACHE"
			set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		"image") set_wallpaper_with_mode "$WALLPAPER_CACHE" || wallSETTERError ;;
		*) verbose warning "Wallpaper type is not configured!\nSo wallpaper is not set...";; 
	esac
}
