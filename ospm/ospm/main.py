#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Usage: ospm <number>...

Examples:
        ospm 1 2 3 23

Options:
        -h --help       Show this screen
'''

from docopt import docopt
from termcolor import cprint


def start():
        arguments = docopt(__doc__)
        numbers = arguments.get('<number>', None)
        if numbers:
                try:
                        numbers = map(int, numbers)
                        for n in numbers:
                                cprint(n, 'yellow')
                except:
                        cprint('ospm only accepts integers', 'red')
        cprint('Hey this is JIAXIN!', 'green')
