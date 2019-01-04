#!/usr/bin/python
# -*- coding:utf-8 -*-

import sys, os, subprocess
import re

print("")

if((not os.path.exists("/usr/bin/pbcopy")) or (not os.path.exists("/usr/bin/pbpaste"))):
    print("Please install pbcopy and pbpaste")
    sys.exit()

def getText():
    p = subprocess.Popen(['pbpaste'], stdout=subprocess.PIPE)
    retStr = p.communicate()[0]
    return retStr.decode("utf-8") 

def setText(data):
    p = subprocess.Popen(['pbcopy'], stdin=subprocess.PIPE)
    p.communicate(data.encode('UTF-8'))

txt = getText()

print("--- Text in Clipboard ---")
print(txt)
print("-------------------------")
print("")

txt = re.sub(r'(\s+)([A-Z0-9]+) (.*),', r'\1\3 \2,', txt)
lines = txt.split('\n')
lines.sort()
txt_sorted = '\n'.join(map(str, lines))
txt_sorted = re.sub(r'([\s\t]+)(.*) ([A-Z0-9]+),', r'\1\3 \2,', txt_sorted)
setText(txt_sorted)

print("--- Text in Clipboard ---")
print(txt_sorted)
print("-------------------------")
print("")
