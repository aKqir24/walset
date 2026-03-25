from argparse import ArgumentParser

from .config import options
from .messages import HELP_MESSAGE 

def read_args():
    parser = ArgumentParser(add_help=False)
    parser.add_argument("--gui", action="append_const", const="gui", dest="modes")
    parser.add_argument("-R", "--reset", action="append_const", const="reset", dest="modes")
    parser.add_argument("-D", "--debug", action="append_const", const="debug", dest="modes")
    parser.add_argument("-V", "--verbose", action="append_const", const="verbose", dest="modes")
    parser.add_argument("-L", "--load", action="append_const", const="load", dest="modes")
    parser.add_argument("-r", "--reload", action="append_const", const="reload", dest="modes")
    parser.add_argument("-h", "--help", action="append_const", const="help", dest="modes")

    return parser.parse_args()

def assign_args(args): 
    setting_options = options['Settings']
    if not args.modes:
        write_ln('walset: Option Not found, you run walset -h or --help to check them!!')
    else:
        for option in args.modes or []:
            setting_options[option] = True
    return setting_options

def condition_args(args_dict):
    if args_dict['help'] is True: 
        print(HELP_MESSAGE)
    
    if args_dict['verbose'] is True:
        from .messages import verbose
    else: 
        def verbose(*_, **__): pass # I'll use a verbose placeholder when it is not enabled!!
    
    if args_dict['gui'] is True:
        from .gui import window # Using lazy loading cause you do not need gui to be imported in CLI mode.
        verbose('Using GUI mode!!')
        window.MainApp()
    else:
        verbose('Using CLI mode!!')

def main():
    # Setup and process the arguments
    condition_args(assign_args(read_args()))

    from . import startup

if __name__ == "__main__":
    main()
