import gi
import logging
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
import importlib.resources as pkg_resources

from . import gtk
from . import setup
from .handler import Signals
from .. import info as app

class Main(Gtk.Builder):
    sub_builder = Gtk.Builder()

    def __init__(self):
        combo_box_ids = {}
        Gtk.Builder.__init__(self)
        
        # Load the Main Shell (no more placeholders = no more crash!)
        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath("window.glade")) as mw:
            self.add_from_file(str(mw)) ; window = self.get_object("MainWindow")

        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath("filedialog.glade")) as fd:
            self.sub_builder.add_from_file(str(fd)) ; path_dialog = self.sub_builder.get_object("pathdialog") 

        # Map the files to the docks
        for tab in ('wallpaper', 'pywal', 'templates'):
            self.plug_in_tab(f'{tab}.glade', f'{tab}_tab', f'{tab}_dock')

        # Get combo_box wallpaper tab info
        for tab_object in ('wall_backs', 'anim_backs', 'wall_mode'):
            combo_box_ids.update({f'{tab_object}': self.sub_builder.get_object(tab_object)})

        # Initial setup
        setup.StartUp(Gtk.CssProvider(), pkg_resources)
        setup.AquireListChoices(combo_box_ids)

        # Handle button's actions
        Signals(self, self.sub_builder, path_dialog) 

        # Show GUI and handle the loop when closing
        window.set_size_request(490, 250)
        window.show_all()
        window.connect("destroy", Gtk.main_quit)

    # Pack or set the tabs in the main window 
    def plug_in_tab(self, file_name, root_id, dock_id):
        with pkg_resources.as_file(pkg_resources.files(gtk).joinpath(file_name)) as p:
            self.sub_builder.add_from_file(str(p))

        if (content := self.sub_builder.get_object(root_id)) and (dock := self.get_object(dock_id)):
            dock.pack_start(content, True, True, 0) 
            content.show_all() 
        else:
            logging.error(f"Failed to bolt {root_id} into {dock_id}—check your IDs!")
