#!/bin/bash

#Add a stack of reminders
remind() {
    if [[ $1 == "--help" ]]; then
        #If the help flag is used, print the help page
            echo Add a reminder, as part of the reminders utility
            echo If no arguments are given, the reminder is taken from the
            echo stdin, if one argument is given, it is taken as the reminder
            echo The --help flag displays the help message
    elif [ "$1" ]; then
        echo "$@" >> ~/.reminder
    else
        cat >> ~/.reminder
    fi
}
unremind() {
    if [[ ! -s ~/.reminder ]]; then
        #Don't do anything if there are no reminders
        echo "There are no reminders to remove"
    elif [[ "$#" -eq 0 ]]; then
        #If the index is not specified, remove the most recent reminder
        head -n-1 ~/.reminder | sponge ~/.reminder
    elif [[ "$1" == "all" ]]; then
        #If the all flag is used, clear all the reminders
        > ~/.reminder
    elif [[ $1 == "--help" ]]; then
        #If the help flag is used, print the help page
        echo Delete a specified reminder, as part of the reminders utility
        echo Takes exactly one argument to specify the index of the reminder to delete
        echo The argument can be of the from \"n\", specifying the index, or
        echo \"i..j\", specifying a range of indices
        echo \"all\" deletes all current reminders
        echo Error messages are written to stdout
        echo The --help flag displays the help message
    elif [[ "$#" -eq 1 ]]; then
        if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
            #Clear a single index
            sed -i "$1d" ~/.reminder

        elif [[ $1 =~ ^([0-9]+)\.\.([0-9]+)$ ]]; then
            #Clear a range of reminders
            startIndex=${BASH_REMATCH[1]} 
            endIndex=${BASH_REMATCH[2]} 
            for rangeIndex in $(seq $startIndex $endIndex); do
                unremind $startIndex 
                ((offsetCount = offsetCount + 1))
            done

        else
            echo Invalid index
        fi
    else
        echo "Only one or a contiguous group of reminder(s) can be removed at a time"
    fi

}
reminders() {
    if [ -f ~/.reminder ]; then
        if [[ ! -s ~/.reminder ]]; then
            echo "You have no reminders"
        elif [[ $1 == "--help" ]]; then
            #If the help flag is used, print the help page
            echo Display the current reminders, as part of the reminders utility
            echo Takes no arguments, sends the current reminders to stdout
            echo The --help flag displays the help message
        else
            echo "Reminders:"
            count=0
            while IFS="" read -r p || [ -n "$p" ]; do
                ((count = count + 1))
                printf '    %s) %s\n' "$count" "$p"
            done < ~/.reminder
        fi
    fi
}



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
    reminders
    echo
    ansiweather -l $(curl -s ipinfo.io/city) -a false | sed 's/^ //g'
}
