import gi
import logging
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from . import  GtkBuilders, setup, get_resource
from .. import info as app

class Main(GtkBuilders):
    def __init__(self):
        # Load the Main Shell (no more placeholders = no more crash!)
        self.gui_elements = {}

        with get_resource("window.xml") as mw:
            self.main_builder.add_from_file(str(mw)) 
            window = self.main_builder.get_object("MainWindow")

        with get_resource.joinpath("filedialog.xml") as fd:
            self.sub_builder.add_from_file(str(fd)) 
            self.gui_elements.update({"wallpaper_path_dialog": self.sub_builder.get_object("pathdialog")})

        # Map the files to the docks
        for tab in ('wallpaper', 'pywal', 'templates'):
            self.plug_in_tab(f'{tab}.xml', f'{tab}_tab', f'{tab}_dock')

        # Initial setup
        setup.StartUp(Gtk.CssProvider(), pkg_resources, self.gui_elements)

        # Show GUI and handle the loop when closing
        window.set_size_request(590, 250)
        window.show_all()
        window.connect("destroy", Gtk.main_quit)

    # Pack or set the tabs in the main window 
    def plug_in_tab(self, file_name, root_id, dock_id):
        with get_resource(file_name) as p:
            self.sub_builder.add_from_file(str(p))

        if (content := self.sub_builder.get_object(root_id)) and (dock := self.main_builder.get_object(dock_id)):
            dock.pack_start(content, True, True, 0) 
            content.show_all() 
        else:
            logging.error(f"Failed to bolt {root_id} into {dock_id}—check your IDs!")
