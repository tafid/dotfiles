#!/usr/bin/env bash

# Install required packages:
# rofi - A window switcher, application launcher and dmenu replacement
# tesseract-ocr - OCR (Optical Character Recognition) Engine
# tesseract-ocr-eng - English language files for Tesseract
# tesseract-ocr-rus - Russian language files for Tesseract
# tesseract-ocr-ukr - Ukrainian language files for Tesseract
# sudo apt install rofi \
#                  tesseract-ocr \
#                  tesseract-ocr-eng \
#                  tesseract-ocr-rus \
#                  tesseract-ocr-ukr

lang=$(printf "eng\nukr\nrus" | rofi -dmenu -p "OCR language:")

[ -z "$lang" ] && exit 0

flatpak run org.flameshot.Flameshot gui --raw \
    | tesseract -l "$lang" stdin stdout \
    | xclip -selection clipboard
