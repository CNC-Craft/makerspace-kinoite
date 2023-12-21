#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir -p /usr/share/appimages

#OpenBuilds-CONTROL 
#Download
curl -s https://api.github.com/repos/OpenBuilds/OpenBuilds-CONTROL/releases/latest \
| grep "browser_download_url.*AppImage" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -nc -O /usr/share/appimages/OpenBuildsCONTROL.AppImage -qi -

wget https://raw.githubusercontent.com/OpenBuilds/OpenBuilds-CONTROL/master/app/icon.png -O /usr/share/icons/OpenBuildsCONTROL.png

#Make executable
chmod +x /usr/share/appimages/OpenBuildsCONTROL.AppImage

#Setup Desktop file
cat > /usr/share/applications/OpenBuildsCONTROL.desktop << EOF
[Desktop Entry]
Type=Application
Name=OpenBuildsCONTROL
Comment=OpenBuildsCONTROL CNC Machine Host Software
Exec=/usr/share/appimages/OpenBuildsCONTROL.AppImage --no-sandbox %U
Icon=OpenBuildsCONTROL
Categories=Graphics;
EOF