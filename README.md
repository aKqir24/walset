
<div align="center" >
    <img height=220 src="https://github.com/user-attachments/assets/a270165b-8fd3-421b-916d-516dca8b364f"></img>
    <br><img src="https://img.shields.io/badge/LATEST-1.1.0-brightgreen?style=for-the-badge"></img>
    <p>A bash script that expands the usage of pywal colors and to ease the configuration in <a href="https://github.com/eylles/pywal16">pywal16</a>.</p></div>

> [!important]
> The script may work in the using the normal `pywal` but it may fail to complete some steps of this script, so please use this fork of pywal called [pywal16](https://github.com/eylles/pywal16) in order to complete some steps in the script, also the wallpapers are not uploaded in the repo, so please configure the wallpaper directory first.
>

<div align="center" >
<video src="https://private-user-images.githubusercontent.com/142222025/516279138-b4b66d0b-c6f2-418f-aafa-efdc0ce85fc0.mp4">
    </video>
    <p>The <a href="https://www.youtube.com/watch?v=swEchSYP3_o">youtube video</a> showcases realtime theme changing.</p>
</div>

## FEATURES
- **Finished**
    - Dialog configuration along with pywal options.
    - Pywal colors to some configurable programs. ( as toml config arrays )
    - Uses the pywal16 option to either have a wallpaper in a folder or just an image.
    - A wallpaper can be set either to `solid_color` or `image`
    - Support for animated gif wallpapersc ( Does not support some gifs | it is a `pywal16` limitation )
    - Wallpaper setup options include [ fill, scale, max, fit, etc ]
    - Gtk theming based [Flat-Remix-GTK](https://github.com/daniruiz/Flat-Remix-GTK) as base theme.
    - Icon colors based [Flat-Remix](https://github.com/daniruiz/Flat-Remix) icon pack.
    - Reload gtk and icon themes using `xsettingd` & `gsettings`.

- **Unfinished**
    - Gui config support using `python-gi`
    - Programs theming configs in `--setup` & `--gui` option.
    - Gif wallpaper support limitation fix.

## SETUP
_**DEPENDENCIES**_
- `pywal16`
- `kdialog`
- `imagemagick`
- `yq`
- `xsettingsd` (optional)
- `python` & `python-gi`(for gui configuration) - In development
- A wallpaper setter (optional):
  - `feh`
  - `hsetroot`
  - `xwallpaper`
  - `nitrogen`
  - `xgifwallpaper` (for gif wallpaper animations)

_**DISTRO**_
  - Debian ( or Other Debian based distro )
  ```bash
  sudo apt install kdialog pipx yq imagemagick xwallpaper
  pipx install pywal16
  ```

  - Arch / AUR
  ```bash
  # You can use something else that works for you like paru
  yay -S kdialog pywal16 yq imagemagick xwallpaper
  ```

## USAGE
Run the following commands in your terminal:

```bash
  git clone https://github.com/aKqir24/walset.git
  cd ~/walset
```

then use these option to configure it:

```bash
bash walsetup.sh [OPTION]
  --gui: To launch a configuration GUI and apply the configurations.
  --setup: Show dialogs that sets up the configurations in order.
  --reset: To remove all set features, and set them all to default.
  --verbose: To show log messages when each step of the script is executed.
  --help: to show how to use this script.
  --load: loads/applies the configurations
```
> [!note]
> Not all are covered like changing the values of a wm config file, in this script yet, so feel free to commit some improvements to it...

## CONFIG 
The config file is located in `$HOME/.config/walset.toml`.
Here is a sample config, I recommend to use it cause it is much easier to setup:
````TOML
[wallpaper]
cycle = "iterative"
type = "image"
path = "/home/akqir24/Pictures/Wallpapers"
mode = "fill"
animated = true

[theming]
gtk = true
icons = true
mode = "dark"
accent = "color2"
[theming.programs]
i3status_rust="/home/akqir24/.files/.config/i3/status/config.toml" 
alacritty="/home/akqir24/.config/alacritty.toml"
rofi="/home/akqir24/.config/rofi/config.rasi"
dunst="/home/akqir24/.config/dunst/dunstrc"

[pywal16]
backend = "wal"
light = "true"
colorscheme = "darken"
````

## SPEACIAL THANKS
- `deviantfero`: [wpgtk's templates](https://github.com/deviantfero/wpgtk-templates) for the _gtk2/3_ base theme.
- `daniruiz`: [Flat-Remix-GTK](https://github.com/daniruiz/Flat-Remix-GTK) for the _gtk4_ base theme.
- `daniruiz`: [Flat-Remix-Icon_Pack](https://github.com/daniruiz/Flat-Remix) for the base icon pack.
- `eylles`: [build-gradience.py](https://github.com/eylles/pywal16-libadwaita/blob/master/scripts/build-gradience.py) it helped me fixed the _gtk4_ issue.
- `eylles`: [pywal16](https://github.com/eylles/pywal16) which make this program possible.
