SET CPath=%CIQ_SDK_Path%
SET AppName=YASailingApp
SET Key=c:\#Sync\Projects\Garmin-Keys\YASailingApp.key

SET Device=%1
IF NOT DEFINED Device (SET Device=fenix3)

java -cp %CPath%\monkeybrains.jar; com.garmin.monkeybrains.Monkeybrains -o bin\%AppName%.prg -d %Device% -f .\monkey.jungle --warn --debug -y %Key% || GOTO :EOF

start %CPath%\simulator.exe 

java -classpath %CPath%\monkeybrains.jar com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f .\bin\%AppName%.prg -d %Device% -s %CPath%\shell.exe

rem %CPath%\monkeydo .\bin\%AppName%.prg %Device%