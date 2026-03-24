from config import *
import argparse

# Setup args options
parser = argparse.ArgumentParser()
parser.add_argument("--gui", action="append_const", const="gui", dest="modes")
parser.add_argument("-R", "--reset", action="append_const", const="reset", dest="modes")
parser.add_argument("-D", "--debug", action="append_const", const="debug", dest="modes")
parser.add_argument("-V", "--verbose", action="append_const", const="verbose", dest="modes")
parser.add_argument("-L", "--load", action="append_const", const="load", dest="modes")
parser.add_argument("-r", "--reload", action="append_const", const="reload", dest="modes")

# Assign args options
args = parser.parse_args()
setting_options = options['Settings'] 
for option in args.modes or []:
    setting_options.update({f"{option}": True})

# Condition of each options
if setting_options['gui'] == True:
    from gui import window
    window.MainApp()
