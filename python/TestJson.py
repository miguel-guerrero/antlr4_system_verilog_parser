#!/usr/bin/env python3
import json
import sys

fileName = 'adder.json'
if len(sys.argv) > 1:
    fileName = sys.argv[1]

with open(fileName) as f:
    d = json.load(f)

print(d)
