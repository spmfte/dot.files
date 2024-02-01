#!/bin/sh

# Source the pywal color file
source ~/.cache/wal/colors.sh

# Copy the template and replace colors
sed -e "s/@background/$background/" \
    -e "s/@foreground/$foreground/" \
    -e "s/@color1/$color1/" \
    ~/.config/rofi/my_template.rasi > ~/.config/rofi/my_theme.rasi

# Launch Rofi with the new theme
rofi -show drun -theme ~/.config/rofi/my_theme.rasi

