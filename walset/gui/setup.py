import gi
from os import environ
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject, Gdk
import importlib.resources as pkg_resources

from .handler import Signals
from . import components
from . import tabs

get_resource = lambda ui_file:pkg_resources.as_file(pkg_resources.files(gtk).joinpath(str(ui_file)))

class GtkBuilders:
    main_builder = Gtk.Builder()
    sub_builder = Gtk.Builder()

class PackTabWidgets:
    def __init__(self, builders):
        pass
    # Wallpaper tab

class RenderChoiceComboBox:
    def __init__(self, combo_box_ids=None, **kwargs):
        # Pass the remaining arguments up the chain
        super().__init__(**kwargs)
        
        self.gtk_stored_list = []
        self.renderer_text_no = []
        
        # Ensure combo_box_ids isn't None before looping
        ids = combo_box_ids or {}
        for _ in range(len(ids)):
            self.gtk_stored_list.append(Gtk.ListStore(GObject.TYPE_STRING))
            self.renderer_text_no.append(Gtk.CellRendererText())

    def append_to_gtk(self, gtk_list, items):
        for item in items:
            gtk_list.append([item])
    
    def pack_combo_items(self, listed_choices, stored_list, renderer_text_no):
        if listed_choices:
            listed_choices.set_model(stored_list) 
            listed_choices.pack_start(renderer_text_no, True)
            listed_choices.add_attribute(renderer_text_no, "text", 0)
            listed_choices.set_active(0)

class AquireListChoices(RenderChoiceComboBox, GtkBuilders):
    def __init__(self):
        self.combo_box_ids = {}
        for tab_object in ('wall_backs', 'anim_backs', 'wall_mode', 'color_backs'):
            obj = self.sub_builder.get_object(tab_object)
            self.combo_box_ids[tab_object] = obj
        super().__init__(self.combo_box_ids)

        combo_values = (self.wallpaper_config(), self.color_backs())
        all_combos = list(self.combo_box_ids.values())
        
        for i, wall_setter in enumerate(combo_values):
            if i < len(self.gtk_stored_list):
                self.append_to_gtk(self.gtk_stored_list[i], wall_setter)
                self.pack_combo_items(
                    all_combo_box[i], 
                    self.gtk_stored_list[i], 
                    self.renderer_text_no[i])

    def wallpaper_config(self):
        if environ.get('WAYLAND_DISPLAY'):
            WALL_SETTERS_STATIC=('awww','swaybg', 'gnome-shell')
            WALL_SETTERS_ANIMATED=('awww', 'script')
        elif environ.get('DISPLAY'):
            WALL_SETTERS_STATIC=('xwallpaper', 'hsetroot', 'feh', 'nitrogen', 'xfconf-query', 'pcmanfm', 'gnome-shell')
            WALL_SETTERS_ANIMATED=('mpv','script','xgifwallpaper')
        else:
            backend = None

        return ( WALL_SETTERS_STATIC, 
                 WALL_SETTERS_ANIMATED, 
                 ('Full', 'Fill', 'Tile', 'Center', 'Crop')) # Wallpaper Modes I lazy was to put it in a variable
    
    def colors_backends():
        pass

class StartUp:
    def __init__(self, style_provider, pkg_resources, gui_elements):
        self.pkg_resources = pkg_resources
        self.load_custom_css(style_provider)
        self.set_config_values()
        AquireListChoices()
        Signals(gui_elements)

    def load_custom_css(self, style_provider):
        try:
            with self.pkg_resources.path("walset.gui", "style.css") as css_path:
                style_provider.load_from_path(str(css_path))
                
            # Apply it to the screen
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(),
                style_provider, # Fixed: matched the variable name above
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        except Exception as e:
            print(f"!!! CSS LOAD ERROR: {e}")
   
    # Use the config file to set the configs the dictionary
    def set_config_values(self):
        pass
