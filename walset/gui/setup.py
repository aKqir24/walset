import gi
from os import environ
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject, Gdk

class StartUp:
    def __init__(self, style_provider, pkg_resources):
        self.pkg_resources = pkg_resources
        self.load_custom_css(style_provider)
        self.set_config_values()

    def load_custom_css(self, style_provider):
        try:
            with self.pkg_resources.path("walset.gui", "style.css") as css_path:
                style_provider.load_from_path(str(css_path))
                
            # Apply it to the screen
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(),
                style_provider, # Fixed: matched the variable name above
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            )
        except Exception as e:
            print(f"!!! CSS LOAD ERROR: {e}")
    
    def set_config_values(self):
        pass

class RenderChoiceList:
    renderer_text_no = ( 
        Gtk.CellRendererText(),
        Gtk.CellRendererText(),
        Gtk.CellRendererText())

    def append_to_gtk(self, gtk_list, items):
        for item in items:
            self.append([item])
    
    def pack_combo_items(self, stored_list, listed_choices, renderer_text_no):
        listed_choices.set_model(stored_list) 
        listed_choices.pack_start(renderer_text_no, True)
        listed_choices.add_attribute(renderer_text_no, "text", 0)
        listed_choices.set_active(0)
    
class WallpaperBackends(Gtk.ListStore, RenderChoiceList):
    def __init__(self, setters):
        super().__init__(GObject.TYPE_STRING)
        backends=self.aquire_setters()
        self.append_to_gtk(self, backends[0])
        self.pack_combo_items(self, setters, self.renderer_text_no[0])

    def aquire_setters(self):
        if environ.get('WAYLAND_DISPLAY'):
            WALL_SETTERS_STATIC=(
                    'awww',
                    'swaybg', 
                    'gnome-shell')
            WALL_SETTERS_ANIMATED=(
                    'awww',
                    'script'
            )
        elif environ.get('DISPLAY'):
            WALL_SETTERS_STATIC=(
                    'xwallpaper', 
                    'hsetroot', 
                    'feh', 
                    'nitrogen', 
                    'xfconf-query', 
                    'pcmanfm', 
                    'gnome-shell'
            )
            WALL_SETTERS_ANIMATED=(
                    'mpv',
                    'script',
                    'xgifwallpaper',
            )
        else:
            backend = None

        return (WALL_SETTERS_STATIC, WALL_SETTERS_ANIMATED)

#class
