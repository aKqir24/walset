#!/usr/bin/env python3

import gi
import info as app
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk

# Main Application Interface
class MainApp(Gtk.Application):

    def __init__(self):
        super().__init__(application_id=app.APPNAME)
        self.run()

    def do_activate(self):
        # Create main window
        self.MAIN_INTERFACE = Gtk.ApplicationWindow(application=self, title=app.TITLE)
        self.MAIN_INTERFACE.set_default_size(400, 300)

        # Create Notebook
        tabs_notebook = Gtk.Notebook()
        self.MAIN_INTERFACE.set_child(tabs_notebook)

        # Assign Tabs To Variables
        config_tabs: dict = {}
        for tab in ('setup', 'paths', 'pywal', 'settings'):
            config_tabs[f'{tab}_tab'] = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=14)
            tabs_notebook.append_page(config_tabs[f'{tab}_tab'], Gtk.Label(label=tab.capitalize()))

        self.MAIN_INTERFACE.present()
