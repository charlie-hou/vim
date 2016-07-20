#!/usr/bin/python

import os
import sys

if __name__ == '__main__':
    base = sys.argv[1]
    theirs = sys.argv[2]
    mine = sys.argv[3]
    merged = sys.argv[4]
    wcpath = sys.argv[5]
    
    cmd = 'vimdiff {0} {1} -c ":bo sp {2}" -c ":diffthis" -c "setl stl=MERGED | wincmd W | setl stl=THEIRS | wincmd W | setl stl=MINE"'.format(mine, theirs, merged)
    os.system(cmd)
