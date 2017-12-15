#!/bin/bash

if [ $KIOSK = "yes" ]; then
   python /opt/maraschino/Maraschino.py --kisok --datadir /config
fi

python /opt/maraschino/Maraschino.py --datadir /config
