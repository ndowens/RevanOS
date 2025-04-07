@echo off
if exist pricetable.zip del pricetable.zip
echo downloading pricetable ...
powershell -command "Invoke-WebRequest -URI https://eu.tamrieltradecentre.com/download/PriceTable -OutFile pricetable.zip"

if NOT exist pricetable.zip  (
echo pricetable not found!

) else (

echo making backup ...

tar -v -a -c -f AddOns\TamrielTradeCentre\backup.zip AddOns\TamrielTradeCentre\*.lua
del AddOns\TamrielTradeCentre\ItemLookUpTable_*.lua
del AddOns\TamrielTradeCentre\PriceTable*.lua

rem ren AddOns\TamrielTradeCentre\ItemLookUpTable_*.lua  ItemLookUpTable_*.bak
rem ren AddOns\TamrielTradeCentre\PriceTable*.lua  PriceTable*.bak

echo done.

echo unzipping ...
powershell -command "Expand-Archive pricetable.zip AddOns\TamrielTradeCentre"
echo done.

echo cleaning ...
del pricetable.zip
echo done.

)

echo program completed.
pause