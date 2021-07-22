#!/usr/bin/env python3
import sys
import os
import re
import csv

from collections import namedtuple


Data = namedtuple('Meassurement', ['ping', 'down', 'up'])

print("[+] Parsing data...")

if len(sys.argv) != 2:
    print("Usage: parse.py <file.log>")

filename = sys.argv[1]
if not os.path.isfile(filename):
    print("File not found!")
    sys.exit(1)

with open(filename) as f:
    lines = f.readlines()

floatRE = '(\d+.\d+) Mbit/s'
pingRE= '(\d+.\d+) ms'

points = []
ping = up = down = 0

for line in lines:
    if line.startswith("Retrieving"):
        ping = up = down = 0
    if line.startswith("Hosted"):
        ping = float(re.findall(pingRE, line)[0])
    if line.startswith("Download"):
        down = float(re.findall(floatRE, line)[0])
    if line.startswith("Upload"):
        up = float(re.findall(floatRE, line)[0])
        points.append(Data(ping, down, up))

if filename.startswith('baseline'):
    csvFile = 'baseline.csv'
else:
    csvFile = 'data.csv'

with open(csvFile, 'w', newline='') as csvfile:
    w = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    w.writerow(["ping", "download", "upload"])
    for p in points:
        w.writerow([p.ping, p.down, p.up])

print('[+] Done:', csvFile)
