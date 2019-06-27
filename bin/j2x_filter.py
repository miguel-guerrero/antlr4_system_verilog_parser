#!/usr/bin/env python

import sys
import json
import dict2xml

s = sys.stdin.read()
d = json.loads(s)
sys.stdout.write('<?xml version="1.0"?>\n')
sys.stdout.write('<top>')
sys.stdout.write(dict2xml.dict2xml(d))
sys.stdout.write('</top>\n')

