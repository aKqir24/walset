#!/usr/bin/env python3

import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk

class MainApp(Gtk.Application):
    APP_ID = "com.aKqir24.walsetgui"

    def __init__(self):
        super().__init__(application_id=self.APP_ID)
        self.run()

    def do_activate(self):
        # Create main window
        self.MAIN_INTERFACE = Gtk.ApplicationWindow(
            application=self,
            title="walset GUI"
        )
        self.MAIN_INTERFACE.set_default_size(400, 300)

        # Create Notebook
        notebook = Gtk.Notebook()
        self.MAIN_INTERFACE.set_child(notebook)

        # Tabs
        setup = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        paths = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        pywal = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        settings = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)

        for tab, label in (
            (setup, "Setup"),
            (paths, "Paths"),
            (pywal, "Pywal"),
            (settings, "Settings")):
            notebook.append_page(tab, Gtk.Label(label=label))

        self.MAIN_INTERFACE.present()

# Start app
MainApp()
