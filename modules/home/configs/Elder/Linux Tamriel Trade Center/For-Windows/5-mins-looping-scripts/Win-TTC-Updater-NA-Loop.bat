@echo off
cls
title Windows TTC Updater

:start
echo Looping Command...
echo Checking Price Table ...
if exist pricetable.zip del pricetable.zip
echo Downloading PriceTable...
powershell -command "Invoke-WebRequest -URI https://us.tamrieltradecentre.com/download/PriceTable -OutFile pricetable.zip"

if NOT exist pricetable.zip  (
echo Pricetable Not Found!

) else (

echo Creating Backup ...
tar -v -a -c -f AddOns\TamrielTradeCentre\backup.zip AddOns\TamrielTradeCentre\*.lua
del AddOns\TamrielTradeCentre\ItemLookUpTable_*.lua
del AddOns\TamrielTradeCentre\PriceTable*.lua

rem ren AddOns\TamrielTradeCentre\ItemLookUpTable_*.lua  ItemLookUpTable_*.bak
rem ren AddOns\TamrielTradeCentre\PriceTable*.lua  PriceTable*.bak

echo DONE.

echo Unzipping ...
powershell -command "Expand-Archive pricetable.zip AddOns\TamrielTradeCentre"
echo DONE.

echo Cleaning ...
del pricetable.zip
echo DONE.

)

timeout /t 300
goto start