#!/bin/bash

# if a password was set, this will run when the program closes
temp_pass_cleanup() {
  echo $PASS | sudo -S -k passwd -d deck
}

# removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

# if the script is not root yet, get the password and rerun as root
if (( $EUID != 0 )); then
    PASS_STATUS=$(passwd -S deck 2> /dev/null)

    # get password
    while [ "$PASSWORD" != "true" ]; do
        PASS=$(zen_nospam --title="Adding a layout change" --width=300 --height=100 --entry --hide-text --text="Enter your sudo/admin password")
        if [[ $? -eq 1 ]] || [[ $? -eq 5 ]]; then
        exit 1
        fi
    if ( echo "$PASS" | sudo -S -k true ); then
        PASSWORD="true"
    else
        zen_nospam --title="Adding a layout change" --width=150 --height=40 --info --text "Incorrect Password"
    fi
  done
  echo "$PASS" | sudo -S -k bash "$0" "$@" # rerun script as root
  exit 1
fi

echo "Install SteamOS 3.5.19!"
sudo steamos-atomupd-client --update-from-url https://steamdeck-images.steamos.cloud/steamdeck/20240422.1/steamdeck-20240422.1-3.5.19.raucb
echo "Reboot!"
shutdown now -r
