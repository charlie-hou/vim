#!/usr/bin/python

import os
import sys

if __name__ == '__main__':
    left = sys.argv[6]
    right = sys.argv[7]
    cmd = 'vimdiff {0} {1}'.format(left, right)
    os.system(cmd)
