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
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        except Exception as e:
            print(f"!!! CSS LOAD ERROR: {e}")
   
    # Use the config file to set the configs the dictionary
    def set_config_values(self):
        pass

class RenderChoiceComboBox:
    gtk_stored_list = []
    renderer_text_no = []

    def __init__(self, combo_box_ids):
        for list_index in range(0,len(combo_box_ids)+1):
            self.gtk_stored_list.append(Gtk.ListStore(GObject.TYPE_STRING))
            self.renderer_text_no.append(Gtk.CellRendererText())

    # Append choices to be stored later for packing
    def append_to_gtk(self, gtk_list, items):
        for item in items:
            gtk_list.append([item])
    
    # A function to pack all the choices from a list to a combo_box
    def pack_combo_items(self, listed_choices, stored_list, renderer_text_no):
        listed_choices.set_model(stored_list) 
        listed_choices.pack_start(renderer_text_no, True)
        listed_choices.add_attribute(renderer_text_no, "text", 0)
        listed_choices.set_active(0)
    
class AquireListChoices(RenderChoiceComboBox):
    combo_box_ids = {}
    
    def __init__(self, sub_builder):
		# Get combo_box wallpaper tab info
        for tab_object in ('wall_backs', 'anim_backs', 'wall_mode'):
            self.combo_box_ids.update({f'{tab_object}': sub_builder.get_object(tab_object)})
        super().__init__(self.combo_box_ids)
        wall_combo=self.wallpaper_config()

        # Append the config frame combo_box_ids from wallpaper tab
        for i, wall_setter in enumerate(wall_combo):
            self.append_to_gtk(self.gtk_stored_list[i], wall_setter)

        # Pack or set the options in the combo_box_ids
        for i,  that_combo_box in enumerate(self.combo_box_ids):
            self.pack_combo_items(
                self.combo_box_ids.get(that_combo_box), 
                self.gtk_stored_list[i], 
                self.renderer_text_no[i])

    def wallpaper_config(self):
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

        return (
                WALL_SETTERS_STATIC, 
                WALL_SETTERS_ANIMATED,
                # Wallpaper Modes to I lazy was to put it in a variable
                ('full', 'fill', 'tile', 'center', 'crop')) 
