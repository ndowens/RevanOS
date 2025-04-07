if you for whatever reason can't start ttc on windows (.net won't update) you can use this script.

(Prices you scan from other shops won't be uploaded to ttc site, so using ttc.exe is preferred, if possible)

extract and save the bat file and put in live folder (C:\Users\%userprofile%\Documents\Elder Scrolls Online\live)
(YOU MUST EXTRACT THE SCRIPT ON THIS DIRECTORY LOCATION OR ELSE YOU WILL HAVE TO COPY THE DOWNLOADED FILES MANUALLY TO THAT SAME LOCATION)
(I tried editing the cmd to go to "Elder Scrolls Online" with the white spaces so you wont have to extract it there but had no luck)

you can create shortcuts of the bat file by right clicking on it and choose "Send To.." click "Desktop" Option.

this file does not need administrator privilege to run, same as my other linux scripts. however they all need internet to get the data files. (feel free to inspect the code)

(It uses tar from relatively newer version of windows 10.)


Extra Info for Advance users:
==================================================================
5-mins-looping-scripts > Force loops after set amount of time
(if you worry about the read/write health of your storage you can edit the script to your preference)
(useful so you don't have to open the file everytime just leaving it in the background)

To edit the timer open the bat file on text editor
go to Line "37"

  timeout /t 300
  
edit "300" to desired time. (seconds to minute conversion)
then save

==================================================================
Looping-with-user-Input > Manual Loop after the script executes it will ask if you want to terminate or restart. (needs user input to loop)
(useful so you don't have to open the file everytime just leaving it in the background)

==================================================================
Single-use-scripts > single usage script that self terminates after execution.

if you want to speed up the termination proccess (default 5 seconds after execution to visually confirm script successfully executed)
open the bat file on text editor
go to Line "35"

	timeout 5 >nul

edit "5" to desired time in seconds.
or
delete the entire line "timeout 5 >nul"  (note that u wont be able to see the terminal command prompts)
then save