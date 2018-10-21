@ECHO OFF

SET CPath=c:\Projects\CIQSDK\connectiq-sdk-win-2.4.9\bin
SET AppName=YASailingApp
SET Key=c:\#Sync\Projects\Garmin-Keys\YASailingApp.key
SET OutDir=c:\Projects\YASailingRelease

rem check that all files are committed
rem
SET GitStatus=""
for /f %%g in ('git status --porcelain') do set GitStatus=%%g

IF NOT %GitStatus% == "" (
	ECHO Uncommited changes should be commited or discarded before publishing
	git status --porcelain
	GOTO :EOF
)

rem get actual version
rem
for /f %%i in ('git rev-list --count HEAD') do set Version=%%i
SET FullVersion=1.0.%Version%
ECHO publishing version %FullVersion%

rem write version to metadata file
rem
echo ^<properties^>^<property id="appVersion" type="string"^>%FullVersion%^</property^>^</properties^> > resources\version.xml
ECHO version file updated

rem prepare the package
rem
java -cp %CPath%\monkeybrains.jar; com.garmin.monkeybrains.Monkeybrains -o %OutDir%\%AppName%.iq -f .\monkey.jungle -y %Key% -e -w -r || GOTO :EOF
ECHO package compiled.

rem add new version file to old commit and tag this commit as published
rem 
git commit --amend --no-edit resources\version.xml
git tag -a Release_%FullVersion% -m "publish %FullVersion%"
ECHO Done.