#!/usr/bin/env python3

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

# Callback function for button click
def on_button_clicked(widget, label):
    label.set_text("Hello, GTK!")

# Create main window
window = Gtk.Window(title="GTK Notebook Example")
window.set_default_size(400, 200)
window.connect("destroy", Gtk.main_quit)

# Create a Notebook (tab container)
notebook = Gtk.Notebook()
window.add(notebook)

# --- Tab 1 ---
tab1_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
tab1_box.set_border_width(10)
label1 = Gtk.Label(label="This is Tab 1")
tab1_box.pack_start(label1, True, True, 0)
button1 = Gtk.Button(label="Click Me on Tab 1")
tab1_box.pack_start(button1, True, True, 0)

# Add Tab 1 to notebook
notebook.append_page(tab1_box, Gtk.Label(label="Tab 1"))

# --- Tab 2 ---
tab2_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
tab2_box.set_border_width(10)
label2 = Gtk.Label(label="This is Tab 2")
tab2_box.pack_start(label2, True, True, 0)
button2 = Gtk.Button(label="Click Me on Tab 2")
tab2_box.pack_start(button2, True, True, 0)

# Add Tab 2 to notebook
notebook.append_page(tab2_box, Gtk.Label(label="Tab 2"))

# Show all widgets
window.show_all()

# Start GTK main loop
Gtk.main()


