import gi
from . import info as app
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
        tabs: list = []
        tabs_notebook = Gtk.Notebook()
        self.MAIN_INTERFACE.set_child(tabs_notebook)

        # Assign Tabs To Variables
        tab_names = ('setup', 'paths', 'pywal', 'settings')
        for tab in tab_names:
            tabs.append(Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=14))
            tabs_notebook.append_page(tabs[tab_names.index(tab)], Gtk.Label(label=tab.capitalize()))

        self.MAIN_INTERFACE.present()
