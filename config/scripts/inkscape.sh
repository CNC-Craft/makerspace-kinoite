#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# This script grabs the latest mightyscape-1.2 repo
# https://github.com/eridur-de/mightyscape-1.2
mkdir -p /usr/share/inkscape/git
mkdir -p /usr/share/inkscape/extensions
git clone https://github.com/alextrical/mightyscape-1.2.git /usr/share/inkscape/git/mightyscape-1.2
mv /usr/share/inkscape/git/mightyscape-1.2/extensions/mightyscape /usr/share/inkscape/extensions/mightyscape
rm -rf /usr/share/inkscape/git

# # This script grabs the latest inkstitch release
# curl -s https://api.github.com/repos/inkstitch/inkstitch/releases/latest \
# | grep "browser_download_url.*x86_64.rpm" \
# | cut -d : -f 2,3 \
# | tr -d \" \
# | xargs wget - -O /tmp/inkstitch.x86_64.rpm
# rpm-ostree install /tmp/inkstitch.x86_64.rpm
# rm /tmp/inkstitch.x86_64.rpm

#Get latest release
# mkdir -p /usr/share/inkscape
curl -s https://api.github.com/repos/inkstitch/inkstitch/releases/latest \
| grep "browser_download_url.*-linux.tar.xz" \
| cut -d : -f 2,3 \
| tr -d \" \
| xargs wget -qO - \
| xz -d \
| tar -xf - -C /usr/share/inkscape/extensions/