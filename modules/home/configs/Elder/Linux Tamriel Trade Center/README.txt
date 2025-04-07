Linux Tamriel Trade Center

Tamriel Trade Center for Linux without the need to setup and run TTC "Client.exe" on "Wine/Proton/Javascript" to update price list.

A simple bash script to update your TTC Listings Data.

I created this in case you have no luck on running the TTC Client on Proton/Wine/Lutris and their other WINE related programs as well as doing additional work like trying it on a Virtual Machine etc... so I instead created this simple script to do the work for me in the background.

This script utilize built-in system tools aside from needing the TTC add-on itself. the only thing you to do is download the script make it executable and run it via terminal.

Dependencies:
Tamriel Trade Centre



Optional Versions

Single Use Scripts
TTC-O PORTPROTON
TTC-O LINUX NATIVE STEAM

Looping Scripts
TTC-LO PORTPROTON
TTC-LO LINUX NATIVE STEAM


INSTALLATION & USAGE: download the latest script of your choice and put it anywhere. then to run the script. "cd" to the script directory ex. cd ~/Downloads and do "chmod u+x script.sh" ex. chmod u+x TTCO-LINUX-STEAM-V2.sh to make it executable and "bash ./script.sh" ex. bash ./TTCO-LINUX-STEAM-V2.sh to run it.




NOTE: for now I only created 2 sub versions for "Linux Steam" and "PortProton".

NOTE: the script is a bash script and was only tested on POP!_OS 21.04/Ubuntu 21.04/Fedora 35 Silverblue. it might work on other Distro's as long as the "Terminal/Console" supports running Bash scripts.

NOTE: for now the script only updates the "PC NA" PriceTable. feel free to edit the link inside the script according to your server.

PriceTable Download Links
EU - https://eu.tamrieltradecentre.com/download/PriceTable
US - https://us.tamrieltradecentre.com/download/PriceTable


Code:

printf '\n'
sleep 1
curl -o ~/Downloads/PriceTable.zip 'https://us.tamrieltradecentre.com/download/PriceTable'
sleep 1



ADDITIONAL INFORMATION

Assuming you didn't change the drive where you installed ESO, here are the list of default locations.

Default "Linux Steam" Directory
"/home/$USER/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"

Default "PortProton" Directory
"/home/$USER/PortWINE/PortProton/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre"

Default "Flatpak-Steam" Directory
"/home/$USER/.var/app/com.valvesoftware.Steam/.steam/root/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"

- (This assumes you installed Steam Flatpak on the user and not system wide.)
- Depending on your system and installation mode. you might need to change "/.var/app/" to "/var/lib/flatpak/app/"


Default "Lutris" Directory
"/home/$USER/Games/Elder Scrolls Online/drive_c/users/user/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"

Editing the location in case you have your game installed on another drive(custom location). Please edit the line of code highlighted in green showed from the example below.

Code:

printf '\n'
mkdir -p "/home/$USER/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"
sleep 2
rsync -auvzhPX --progress ~/Downloads/PriceTable/. "/home/$USER/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"
sleep 1


© 2021 by APHONIC. All rights reserved

This script was created using content and materials from Tamriel Trade Center © 2015 by Steven Chen. I am not affiliated with Tamriel Trade Center, and Tamriel Trade Center is not responsible for any of the content on, or the privacy policy of this site.

