import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from . import change
from ..config import config

class Signals:
    def __init__(self, builders, elements):
        self.builders = builders

        # Gather all the signal funtions in to a dictionary for easy access
        main_handlers = { 
            "quit_main_app": Gtk.main_quit,
            "app_main_app": self.apply_main
        }
        sub_handlers = {
            "get_wallpaper_path": lambda on_click: self.get_wallpaper_path(elements['wallpaper_path_dialog']) 
        }
        
        # Connect both builders to THIS class instance
        builders.main_builder.connect_signals(main_handlers)
        builders.sub_builder.connect_signals(sub_handlers)
        
        # Assign a classes for each UI element
        self.change_wallpaper = change.WallpaperTab
        
    # WallpaperTab 
    def get_wallpaper_path(self, path_dialog):
        if path_dialog.run() == Gtk.ResponseType.ACCEPT:
            file_path=self.builders.sub_builder.get_object("wallpaper_path_chosen").get_filename()
            self.change_wallpaper.wallpaper_path_label(self, file_path)
            config['Wallpaper'].update({"path": file_path})
        path_dialog.hide()
    
    # MainNotebook
    def apply_main(self): pass
