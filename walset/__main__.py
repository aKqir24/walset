import logging
from argparse import ArgumentParser

from . import startup
from .config import options, check_config, assign_config 

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
        print('Option Not found, you run walset -h or --help to check them!!')
    else:
        for option in args.modes or []:
            setting_options[option] = True
    return setting_options

def main():
    # Setup and process the arguments
    args_dict = assign_args(read_args())

    if args_dict['help'] is True: 
        from .messages import HELP_MESSAGE
        print(HELP_MESSAGE), exit(0)
    
    if args_dict['verbose'] is True:
        from .messages import setup_logging
        setup_logging()
    else:
        logging.disable(logging.CRITICAL) 
    
    if args_dict['gui'] is True:
        from .gui import window # Using lazy loading cause you do not need gui to be imported in CLI mode.
        logging.info('Using GUI mode!!')
        window.Main()
    else:
         logging.info('Using CLI mode!!')

    # Manage config values
    check_config(), assign_config()

if __name__ == "__main__": main()
