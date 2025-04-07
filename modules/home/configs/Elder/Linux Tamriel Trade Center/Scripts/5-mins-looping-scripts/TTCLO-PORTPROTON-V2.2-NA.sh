#!/bin/bash
while [ true ]; do
echo -en "\033]0;APH-TECH TERMINAL\a" 

# ==============================================
cd ~/Downloads &&
# ==============================================
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

printf 'Loading Script ' "\e[0;92m" "\e[0m"
spinner &

sleep 5

kill "$!"
printf '\n'
clear
# ==============================================
echo -ne "\e[0;92m" "[Script created by APHONIC]"
echo -e "\e[0m"
echo -n -e "\e[0;94m" "[https://github.com/MissAphonic/Linux-Tamriel-Trade-Center]"
printf '\n'
# ==============================================
echo -e "\e[0;102m${expand_bg}" "Date of usage: [$(date +%m)] $(date +%B) $(date +%d) [$(date +%A)], $(date +%Y)" "\e[0m"
echo -e "\e[0;104m${expand_bg}" "Time of usage in 24 hour format = $(date +%T)" "\e[0m"
echo -e "\e[0;104m${expand_bg}" "Time of usage in 12 hour format = $(date +%r)" "\e[0m"
# ==============================================
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"
# ==============================================
# This script is created by APHONIC
# ==============================================
echo -e "\e[0;102m${expand_bg}"
echo -e "\e[0;101m${expand_bg}" "\e[1m" "\e[0;94m" "Initializing${reset}" "\e[0m"
sleep 3
echo -e "\e[0;102m${expand_bg}" "Starting Loop Sequence..." "\e[0m"
sleep 2
echo -n -e "\e[0;101m${expand_bg}" "Downloading PriceTable..." "\e[0m"
sleep 1
printf '\n'
sleep 1
curl -o ~/Downloads/PriceTable.zip 'https://us.tamrieltradecentre.com/download/PriceTable'
sleep 1
printf '\n'
echo -n -e "\e[0;92m" "\\r${CHECK_MARK} PriceTable Downloaded" "\e[0m"
sleep 1
printf '\n'
echo -n -e "\e[0;101m${expand_bg}" "Unzipping PriceTable..." "\e[0m"
sleep 1
printf '\n'
unzip -o ~/Downloads/PriceTable.zip -d ~/Downloads/PriceTable
sleep 1
cd ~/Downloads/PriceTable 
sleep 1
printf '\n'
echo -n -e "\e[0;92m" "\\r${CHECK_MARK} PriceTable Unzipped" "\e[0m"
sleep 1
printf '\n'
echo -n -e "\e[0;101m${expand_bg}" "Updating Previous PriceTable..." "\e[0m"
sleep 1
printf '\n'
mkdir -p "/home/$USER/PortWINE/PortProton/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"
sleep 2
rsync -auvzhPX --progress ~/Downloads/PriceTable/. "/home/$USER/PortWINE/PortProton/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"
sleep 1
cd ~/Downloads/PriceTable
sleep 1
printf '\n'
echo -n -e "\e[0;92m" "\\r${CHECK_MARK} Update done" "\e[0m"
sleep 1
printf '\n'
echo -n -e "\e[0;101m${expand_bg}" "Removing Temporary Files..." "\e[0m"
sleep 1
printf '\n'
rm -f ItemLookUpTable_DE.lua ItemLookUpTable_EN.lua ItemLookUpTable_FR.lua ItemLookUpTable_RU.lua ItemLookUpTable_ZH.lua PriceTable.lua
sleep 1
cd ~/Downloads
sleep 1
rm -rv PriceTable
sleep 1
rm -f "./PriceTable.zip"
sleep 1
printf '\n'
echo -n -e "\e[0;92m" "\\r${CHECK_MARK} Temp Files Removed" "\e[0m"
sleep 1
echo -n "..."
sleep 1
clear
echo -n -e "\e[0;101m${expand_bg}" "Restarting Sequence..." "\e[0m"
sleep 5
clear
echo -e "\e[0m"
sleep 2
 hour=0
 min=5
 sec=0
        while [ $hour -ge 0 ]; do
                 while [ $min -ge 0 ]; do
                         while [ $sec -ge 0 ]; do
                                 echo -ne "\e[0;101m${expand_bg}" "\e[1m" "\e[0;94m" "Restart Sequence Countdown: ""$hour:$min:$sec\033[0K\r" "\e[0m"
                                 let "sec=sec-1"
                                 sleep 1
                         done
                         sec=59
                         let "min=min-1"
                 done
                 min=59
                 let "hour=hour-1"
         done
echo -e "\e[0m"
clear
done
