SET CPath=c:\Projects\CIQSDK\connectiq-sdk-win-2.4.9\bin\
SET AppName=YASailingApp
SET Key=c:\#Sync\Projects\Garmin-Keys\YASailingApp.key

SET Device=%1
IF NOT DEFINED Device (SET Device=fenix3)

%CPath%monkeyc -o bin\%AppName%.prg -d %Device% -f .\monkey.jungle --warn --debug -y %Key% && %CPath%connectiq && %CPath%monkeydo .\bin\%AppName%.prg %Device%