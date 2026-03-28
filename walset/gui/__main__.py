import gi
import logging
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
import importlib.resources as pkg_resources

from . import gtk
from . import setup
from .. import info as app

class Main(Gtk.Builder):
    sub_builder = Gtk.Builder()

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
        }

        # Initial setup
        setup.StartUp(Gtk.CssProvider(), pkg_resources)
        setup.WallpaperBackends(wallpaper_tab_objects['backends'])

        # Show GUI and handle the loop when closing
        window.set_size_request(645, 250)
        window.show_all()
        window.connect("destroy", Gtk.main_quit)

    def plug_in_tab(self, file_name, root_id, dock_id):
        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath(file_name)) as p:
            self.sub_builder.add_from_file(str(p))

        if (content := self.sub_builder.get_object(root_id)) and (dock := self.get_object(dock_id)):
            dock.pack_start(content, True, True, 0) ; content.show_all() 
            self.sub_builder.connect_signals(self)
        else:
            logging.error(f"Failed to bolt {root_id} into {dock_id}—check your IDs!")
