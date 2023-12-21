#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
#SheetCAM
wget https://www.sheetcam.com/Downloads/akp3fldwqh/SheetCam_setupV7.1.35-64.bin --show-progress -nc -q -P /tmp 
# unzip /tmp/SheetCam_setupV7.1.35-64.bin "data/*" -d /usr/share/SheetCam
7z x -O/usr/share/SheetCam '-i!data/*' /tmp/SheetCam_setupV7.1.35-64.bin
chmod 755 /usr/share/SheetCam
chmod 755 /usr/share/SheetCam/data
cat > /usr/share/applications/SheetCAM.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Value=1.0
Type=Application
Name=SheetCam TNG
GenericName=CAM software
Comment=SheetCam TNG
Categories=Graphics
Exec="/usr/share/SheetCam/data/run-sheetcam"
Icon=/usr/share/SheetCam/data/resources/sheetcamlogo.png
EOF
chmod +x /usr/share/applications/SheetCAM.desktop