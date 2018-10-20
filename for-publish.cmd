SET CPath=c:\Projects\CIQSDK\connectiq-sdk-win-2.4.9\bin
SET AppName=YASailingApp
SET Key=c:\#Sync\Projects\Garmin-Keys\YASailingApp.key
SET OutDir=c:\Projects\YASailingRelease

for /f %%i in ('git rev-list --count HEAD') do set Version=%%i
SET FullVersion=1.0.%Version%

echo ^<properties^>^<property id="appVersion" type="string"^>%FullVersion%^</property^>^</properties^> > resources\version.xml

%CPath%\monkeyc -o %OutDir%\%AppName%.iq -f .\monkey.jungle -y %Key% -e -w -r
rem && git tag -a v%FullVersion% -m 'publish %FullVersion%'