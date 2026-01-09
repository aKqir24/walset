#!/usr/bin/env python3

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

# Create main self window
class MainWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="walset GUI")
        self.set_default_size(400, 200)
        self.connect("destroy", Gtk.main_quit)
        
        # Create a Notebook (tab container)
        notebook = Gtk.Notebook()
        self.add(notebook)
        
        # Tabs [ Setup, Paths, Pywal, Settings ]
        setup = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        paths = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        pywal = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        settings = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        
        # Add Tabs to Notebook, Labels & Config
        tabs: list = [ (setup, 'Setup'), (paths, 'Paths'), (pywal, 'Pywal'), (settings, 'Settings') ]
        for tab, tab_label in tabs:
            notebook.append_page(tab, Gtk.Label(label=tab_label))
            tab.set_border_width(10)

        # Show all widgets
        self.show_all()

# Start GTK main loop
MainWindow().show_all()
Gtk.main()
