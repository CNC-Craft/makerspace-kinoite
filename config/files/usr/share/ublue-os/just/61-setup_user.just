# vim: set ft=make :

# Create User account, and populate settings
createUser:
    #!/usr/bin/env bash

    #Cleanup any existing account, and start fresh
    userdel makerspace
    rm -r /home/makerspace


    #Allow Passwordless Login, Add if it doesnt exist
    grep -qxF 'auth       sufficient      pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/sddm || sed -i '1 i\auth       sufficient      pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/sddm
    grep -qxF 'auth       sufficient      pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/kde || sed -i '1 aauth       sufficient      pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/kde

    #Create groups
    grep -qF 'dialout:x' /etc/group || grep -E '^dialout:' /usr/lib/group >> /etc/group
    grep -qF 'users:x:100' /etc/group || grep -E '^users:' /usr/lib/group >> /etc/group
    grep -qF 'nopasswdlogin:x' /etc/group || groupadd -r nopasswdlogin

    #User Autologin
    grep -qxF 'User=makerspace' /etc/sddm.conf || sed -i "s/#User=/User=makerspace/g" /etc/sddm.conf
    grep -qxF 'Session=plasma.desktop' /etc/sddm.conf || sed -i 's/#Session=/Session=plasma.desktop/g' /etc/sddm.conf

    #Create User
    adduser -mG nopasswdlogin,dialout,users -c "Maker Space" makerspace

    #Set admin avatar
    cp /usr/share/plasma/avatars/photos/Shuttle.png /var/lib/AccountsService/icons/admin

    #Set user avatar
    cp /usr/share/plasma/avatars/photos/Pencils.png /var/lib/AccountsService/icons/makerspace
    echo "[User]" | tee /var/lib/AccountsService/users/makerspace
    echo "Icon=/var/lib/AccountsService/icons/makerspace" | tee -a /var/lib/AccountsService/users/makerspace

    #Copy files into User folder
    cp -r /usr/share/makerspace-os/user/. /home/makerspace
    chown makerspace:makerspace -R /home/makerspace

    #Enable Automount of USB drives, equivalent to GUI: System Settings → Hardware → Removable Storage → Removable Devices
    kwriteconfig5 --file /home/makerspace/.config/kded_device_automounterrc --group General --key AutomountEnabled true
    kwriteconfig5 --file /home/makerspace/.config/kded_device_automounterrc --group General --key AutomountOnLogin true
    kwriteconfig5 --file /home/makerspace/.config/kded_device_automounterrc --group General --key AutomountOnPlugin true
    kwriteconfig5 --file /home/makerspace/.config/kded_device_automounterrc --group General --key AutomountUnknownDevices true

    #Dissable forced logout
    kwriteconfig5 --file /home/makerspace/.config/kscreenlockerrc --group Daemon --key Autolock false
    kwriteconfig5 --file /home/makerspace/.config/kscreenlockerrc --group Daemon --key LockOnResume false
    kwriteconfig5 --file /home/makerspace/.config/kscreenlockerrc --group Daemon --key LockGrace 300

    #Add system monitor to Ctrl Shift esc
    kwriteconfig5 --file /home/makerspace/.config/kglobalshortcutsrc --group org.kde.plasma-systemmonitor.desktop --key _k_friendly_name System Monitor
    kwriteconfig5 --file /home/makerspace/.config/kglobalshortcutsrc --group org.kde.plasma-systemmonitor.desktop --key _launch Ctrl+Shift+Esc,none,System Monitor


    ######### Setup symbolic links #########
    mkdir -P /home/makerspace/.var/app/org.inkscape.Inkscape/config/inkscape/extensions
    ln -s /usr/share/inkscape/extensions/inkstitch /home/makerspace/.var/app/org.inkscape.Inkscape/config/inkscape/extensions/inkstitch
    ln -s /usr/share/inkscape/extensions/mightyscape /home/makerspace/.var/app/org.inkscape.Inkscape/config/inkscape/extensions/mightyscape
    chown makerspace:makerspace -R /home/makerspace