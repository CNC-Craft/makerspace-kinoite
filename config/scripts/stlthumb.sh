#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
wget https://github.com/alextrical/stl-thumb/releases/download/release/stl-thumb-0.5.0-1.x86_64.rpm -P /tmp
rpm-ostree install /tmp/stl-thumb-0.5.0-1.x86_64.rpm
rm /tmp/stl-thumb-0.5.0-1.x86_64.rpm
wget https://github.com/alextrical/stl-thumb-kde/releases/download/Release/stlthumbnail.so -P /usr/lib64/qt5/plugins
chmod +x /usr/lib64/qt5/plugins/stlthumbnail.so
wget https://github.com/alextrical/stl-thumb-kde/releases/download/Release/stlthumbnail.desktop -P /usr/share/kservices5