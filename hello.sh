#!/bin/bash

#Display system information
system() {
    if [ -f ~/.hushlogin ]; then
        for i in /etc/update-motd.d/*; do if [[ "$i" != "/etc/update-motd.d/98-fsck-at-reboot" && "$i" != "/etc/update-motd.d/removed-motd-files" ]]; then $i; fi; done
    fi
}

#Fully upgrade all apt installed software, and delete any unnecessary software
aptfullupgrade() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt full-upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y
}

#Display a hello message 
hello() {
    echo Hello $(whoami)!
    echo
    echo It is $(date) 
    echo
    echo
    ansiweather -l $(curl -s ipinfo.io/city) -a false | sed 's/^ //g'
}
