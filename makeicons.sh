#!/bin/bash
# brew install imagemagick
# http://www.imagemagick.org/
for s in 16 48 128; do
  convert icon.png -resize "${s}x${s}" "icon${s}.png"
done
