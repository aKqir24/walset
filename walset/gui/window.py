import gi
import logging
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk
import importlib.resources as pkg_resources

from . import setup
from .. import info as app
from . import gtk 

class Main(Gtk.Builder):
    sub_builder = Gtk.Builder()
    style_provider = Gtk.CssProvider()

    def __init__(self):
        Gtk.Builder.__init__(self)
        
        # Load the Main Shell (no more placeholders = no more crash!)
        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath("window.glade")) as p:
            self.add_from_file(str(p)) ; window = self.get_object("MainWindow")

        # Map the files to the docks
        for tab in ('wallpaper', 'pywal', 'templates'):
            self.plug_in_tab(f'{tab}.glade', f'{tab}_tab', f'{tab}_dock')

        # Get wallpaper tab info
        wallpaper_tab_objects = {
            "backends": self.sub_builder.get_object("wallpaper_backends"),
            "animated": self.sub_builder.get_object("wallpaper_backends") 
        }
        wallpaper_backends = setup.WallpaperBackends()
        wallpaper_backends.aquire_setters(wallpaper_tab_objects)
        
        # Load Css and apply
        self.load_custom_css()

        # Show GUI and handle the loop when closing
        window.show_all()
        window.connect("destroy", Gtk.main_quit)
    
    def load_custom_css(self):
        try:
            with pkg_resources.path("walset.gui", "style.css") as css_path:
                self.style_provider.load_from_path(str(css_path))
                
            # 3. Apply it to the screen
            screen = Gdk.Screen.get_default()
            Gtk.StyleContext.add_provider_for_screen(
                screen,
                self.style_provider, # Fixed: matched the variable name above
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            )
        except Exception as e:
            print(f"!!! CSS LOAD ERROR: {e}")

    def plug_in_tab(self, file_name, root_id, dock_id):
        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath(file_name)) as p:
            self.sub_builder.add_from_file(str(p))

        if (content := self.sub_builder.get_object(root_id)) and (dock := self.get_object(dock_id)):
            dock.pack_start(content, True, True, 0) ; content.show_all() 
            self.sub_builder.connect_signals(self)
        else:
            logging.error(f"Failed to bolt {root_id} into {dock_id}—check your IDs!")
