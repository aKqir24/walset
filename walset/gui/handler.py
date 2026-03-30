import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class Signals:
    def __init__(self, builder, sub_builder, path_dialog):
        self.builder = builder
        self.sub_builder = sub_builder

        handlers = {
                "get_wallpaper_path": lambda on_click: self.get_wallpaper_path(path_dialog)
        }
        
        # Connect both builders to THIS class instance
        self.sub_builder.connect_signals(handlers)

    def get_wallpaper_path(self, path_dialog):
        if path_dialog.run() == Gtk.ResponseType.ACCEPT:
            self.sub_builder.get_object("wall_path_preview").set_text(
                    self.sub_builder.get_object("wallpaper_path_chosen").get_filename())
       
        path_dialog.hide()
