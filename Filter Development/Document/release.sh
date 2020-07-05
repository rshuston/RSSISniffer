#!/bin/sh
if [ -f rssi-filter.pdf ]; then
  cp rssi-filter.pdf rssi-filter-$(date "+%Y-%m-%d").pdf
fi
