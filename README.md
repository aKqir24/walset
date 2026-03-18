
<div align="center" >
<img height=220 alt="wide_stylish_text" src="https://github.com/user-attachments/assets/a270165b-8fd3-421b-916d-516dca8b364f"></img>

![Code size](https://img.shields.io/github/languages/code-size/aKqir24/walset?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/aKqir24/walset?style=for-the-badge)
![Codacy grade](https://img.shields.io/codacy/grade/3d58744e1c654c41a5d91562920c6bc0?style=for-the-badge)
![GitHub License](https://img.shields.io/github/license/aKqir24/walset?style=for-the-badge)

A bash script that expands the usage of `pywal16's` colors and to ease the configuration.
</div>

> [!important]
> The script may work in the using the normal `pywal` but it may fail to complete some steps of this script, so please use this fork of pywal called [pywal16](https://github.com/eylles/pywal16) in order to complete some steps in the script, also the wallpapers are not uploaded in the repo, so please configure the wallpaper directory first.
>

<div align="center" >
<video src="https://private-user-images.githubusercontent.com/142222025/516279138-b4b66d0b-c6f2-418f-aafa-efdc0ce85fc0.mp4"></video>

The [youtube video](https://www.youtube.com/watch?v=swEchSYP3_o) showcases realtime theme changing.
</div>

## FEATURES

  - Dialog configuration along with pywal options.
  - Choose between `solid_color` or `image` in wallpaper setting.
  - Wallpaper setup options include [ fill, scale, max, fit, etc ]
  - Pywal colors to some configurable programs.( as toml config arrays )
  - Use a wallpaper folder or image in pywal16.
  - Gtk theming based [Flat-Remix-GTK](https://github.com/daniruiz/Flat-Remix-GTK) as base theme.
  - Icon theme colors based [Flat-Remix](https://github.com/daniruiz/Flat-Remix) icon pack.
  - Reload gtk and icon themes using `xsettingd` & `gsettings`.(only icon theme reloading in wayland)
  - Full Gif wallpaper support(please update to the latest pywal16 version).
  - GUI config support


## SETUP

_**DEPENDENCIES**_
- **Required**
    - `python3-tomli`
    - `python3-tomli-w`
    - `python3-pywal16`
    - `imagemagick`

- **Optional**
    - `python3-gi` <sup>(GUI configuration)</sup>
    - `xsettingsd` <sup>(reload_gtk & icons)</sup>
    - `libxapp-gtk3-module` <sup>(gtk3 decorations)</sup>
    - `gtk2-engines-murrine` <sup>(gtk2 support)</sup>

  	A wallpaper setter (optional):
  	- `feh`
	- `hsetroot`
  	- `xwallpaper`
	- `nitrogen`
   	- `xgifwallpaper` <sup>(gif wallpaper animations on x11)</sup>
  	- `swaybg`
  	- `swww`
    - `awww` <sup>(gif wallpaper on wayland)</sup>

_**DISTRO**_

If the main script did not work as it intended you might need to follow these options.

- Debian ( or Other Debian based distro )

```bash
sudo apt install imagemagick xwallpaper python3-gi python3-tomli
sudo pacsatall -I python3-pywal16 # You need to install pacstall for this...
```

- Arch / AUR

```bash
# You can use something else that works for you like paru
yay -S kdialog pywal16 yq imagemagick xwallpaper
```

## USAGE

Run the following commands in your terminal:

```bash
  git clone --recursive https://github.com/aKqir24/walset.git
  cd ~/walset
```

then use these option to configure it:

```bash
bash walset [OPTION]
  --gui: To launch a configuration GUI and apply the configurations.
  -D | --debug: shows all the messages of this script.
  -R | --reload: enables programs to reload after running pywal, eg.(gtk|icons|wm)
  -r | --reset: To remove all set features, and set them all to default.
  -V | --verbose: To show log messages when each step of the script is executed.
  -h | --help: to show how to use this script.
  -h | --help: to show how to use this script, (this is ignored sometimes ignored).
  -L | --load: loads/applies the configurations.
```
> [!note]
> Not all are covered like changing the values of a wm config file, in this script yet, so feel free to commit some improvements to it...

## CONFIG

The config files are located in `$HOME/.config/walset`.
Here is a sample config, I recommend to use it cause it is much easier to setup:

**config.toml**
````TOML

[wallpaper]
cycle = "iterative"
type = "image"
path = "/home/akqir24/Pictures/Wallpapers"
mode = "fill"
animated = true

[theming]
mode = "dark"
accent = 2

[pywal16]
light = true
reload = true
backend = "wal"
colorscheme = "lighten"

````

**programs.toml**
````TOML
[status]
i3status_rust = "/home/akqir24/.files/.config/i3/status/config.toml"

[terminal]
alacritty = "/home/akqir24/.config/alacritty.toml"

[launcher]
rofi = "/home/akqir24/.config/rofi/config.rasi"

[notification]
dunst = "/home/akqir24/.config/dunst/dunstrc"
`````

## SPEACIAL THANKS

- `deviantfero`: [wpgtk's templates](https://github.com/deviantfero/wpgtk-templates) for the _gtk2/3_ reference theme format.
- `daniruiz`: [Flat-Remix-GTK](https://github.com/daniruiz/Flat-Remix-GTK) for the _gtk2,3,4_ base theme.
- `daniruiz`: [Flat-Remix-Icon_Pack](https://github.com/daniruiz/Flat-Remix) for the base icon pack.
- `eylles`: [build-gradience.py](https://github.com/eylles/pywal16-libadwaita/blob/master/scripts/build-gradience.py) it helped me fixed the _gtk4_ issue.
- `eylles`: [pywal16](https://github.com/eylles/pywal16) which make this program possible.
