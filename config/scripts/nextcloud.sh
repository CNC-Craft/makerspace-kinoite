#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail


#Nextcloud Desktop
mkdir -p /usr/share/appimages
mkdir -p /tmp/Nextcloud

#Download
curl -s https://api.github.com/repos/nextcloud-releases/desktop/releases/latest \
| grep "browser_download_url.*AppImage\"" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -nc -O /usr/share/appimages/Nextcloud-x86_64.AppImage -qi -

#Make executable
chmod +x /usr/share/appimages/Nextcloud-x86_64.AppImage

#Extract
(cd /tmp/Nextcloud && /usr/share/appimages/Nextcloud-x86_64.AppImage --appimage-extract)

mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/16x16/apps/* /usr/share/icons/hicolor/16x16/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/24x24/apps/* /usr/share/icons/hicolor/24x24/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/32x32/apps/* /usr/share/icons/hicolor/32x32/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/48x48/apps/* /usr/share/icons/hicolor/48x48/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/64x64/apps/* /usr/share/icons/hicolor/64x64/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/72x72/apps/* /usr/share/icons/hicolor/72x72/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/128x128/apps/* /usr/share/icons/hicolor/128x128/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/256x256/apps/* /usr/share/icons/hicolor/256x256/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/512x512/apps/* /usr/share/icons/hicolor/512x512/apps
mkdir -p /usr/share/icons/hicolor/1024x1024/apps
mv /tmp/Nextcloud/squashfs-root/usr/share/icons/hicolor/1024x1024/apps/* /usr/share/icons/hicolor/1024x1024/apps

#Setup Desktop file
mv /tmp/Nextcloud/squashfs-root/com.nextcloud.desktopclient.nextcloud.desktop /usr/share/applications/Nextcloud.desktop
sed -i 's@Exec=nextcloud@Exec=/usr/share/appimages/Nextcloud-x86_64.AppImage@g' /usr/share/applications/Nextcloud.desktop