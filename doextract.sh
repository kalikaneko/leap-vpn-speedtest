#!/bin/sh
grep sender data/perf-seattle-tcp* | awk '{print $7,$9}' > data/data-tcp.csv
grep sender data/perf-seattle-udp* | awk '{print $7,$9}' > data/data-udp.csv

