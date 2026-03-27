import gi
from os import environ
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject

class WallpaperBackends(Gtk.ListStore):
    def __init__(self):
        super().__init__(GObject.TYPE_STRING)
    
    def aquire_setters(self, obj):
        if environ.get('WAYLAND_DISPLAY'):
            WALL_SETTERS_STATIC=('awww', 'swaybg', 'gnome-shell')
            WALL_SETTERS_ANIMATED=('awww',)
        elif environ.get('DISPLAY'):
            WALL_SETTERS_STATIC=('xwallpaper', 'hsetroot', 'feh', 'nitrogen', 'xfconf-query', 'pcmanfm', 'gnome-shell')
            WALL_SETTERS_ANIMATED=('xgifwallpaper',)
        else:
            backend = None

        animated=True
        if animated is False:
            backends = (WALL_SETTERS_STATIC)
        else:
            backends = (WALL_SETTERS_ANIMATED)
        print(backends)
        self.append(["pywal"])
        for item in backends:
            self.append([item])
    
        obj['backends'].set_model(self)
        renderer_text = Gtk.CellRendererText()
        obj['backends'].pack_start(renderer_text, True)
        obj['backends'].add_attribute(renderer_text, "text", 0)
        obj['backends'].set_active(0)
