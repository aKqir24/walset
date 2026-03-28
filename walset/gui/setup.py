import gi
from os import environ
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject, Gdk

class StartUp:
    def __init__(self, style_provider, pkg_resources):
        self.style_provider = style_provider
        self.pkg_resources = pkg_resources
        self.load_custom_css()
        self.set_config_values()

    def load_custom_css(self):
        try:
            with self.pkg_resources.path("walset.gui", "style.css") as css_path:
                self.style_provider.load_from_path(str(css_path))
                
            # Apply it to the screen
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(),
                self.style_provider, # Fixed: matched the variable name above
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            )
        except Exception as e:
            print(f"!!! CSS LOAD ERROR: {e}")
    
    def set_config_values(self):
        pass
    
class WallpaperBackends(Gtk.ListStore):
    def __init__(self, setters):
        super().__init__(GObject.TYPE_STRING)
        self.setters = setters
        self.aquire_setters()
    
    def aquire_setters(self):
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
        self.append(["pywal"])
        for item in backends:
            self.append([item])
    
        self.setters.set_model(self)
        renderer_text = Gtk.CellRendererText()
        self.setters.pack_start(renderer_text, True)
        self.setters.add_attribute(renderer_text, "text", 0)
        self.setters.set_active(0)
