class GetBuilders:
    def __init__(self, main_builder, sub_builder):
        self.main_builder = main_builder
        self.sub_builder = sub_builder

class WallpaperTab(GetBuilders):
    wallpaper_path_label = lambda self, wallpaper_path: \
        self.sub_builder.get_object("wall_path_preview").set_text(wallpaper_path)

#class MainNotebook(Builders):
#    def apply_main():
