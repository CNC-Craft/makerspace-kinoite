#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Lightburn
#Download
curl -s https://api.github.com/repos/LightBurnSoftware/deployment/releases/latest \
| grep "browser_download_url.*7z" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -nc -O /tmp/LightBurn-Linux64.7z --show-progress -qi -

#extract 7z to application share
7z x -t7z /tmp/LightBurn-Linux64.7z -o/usr/share/

#Setup Desktop file
cat > /usr/share/applications/lightburn.desktop << EOF
[Desktop Entry]
Type=Application
Name=LightBurn
Comment=Better Software For Laser Cutters
Exec=/usr/share/LightBurn/LightBurn
Icon=/usr/share/LightBurn/LightBurn.png
Categories=Graphics;
EOF