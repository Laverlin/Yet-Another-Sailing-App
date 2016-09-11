# Yet-Another-Sailing-App
Simple app for garmin quatix 3 to track speed and bearing during cruise. 

**description**

There is already a few nice sailing apps but this yet another one... =)
Here is a two mode - Race Timer mode with ISAF starting sequence support and Cruise mode
In *Cruise* mode you can see at one glance actual speed, bearing, max speed and avg speed for last 10 seconds. Also there is a set of helpful indicators, like GPS status, recording status and actual speed vs avg speed, which is very useful for sail trimming.
In *Race Timer* mode you can see remaining seconds till start, actual time and speed. You can also ajust countdown timer by one sec up and down and down to next minute. 

Waypoint mode is under development.

**usage**

In *Cruise* mode
- press and hold UP button (over 2 sec.) to get access to main menu.
In main menu you can
-- switch to Race Timer mode
-- setup timer for Race Timer mode
-- view laps statistic from current session (max speed, avg speed, distance and duration)
-- change color scheme
-- set auto recording option (recording activity can start automaticaly as soon as GPS signal available) 

- press start/stop button to start/stop recording. This option available only if GPS signal strong enough (gps indicator yellow or green)

- press back button to add new lap, you can view laps statistic later.

In *Rase Timer* mode

- UP button add one second to countdown timer
- DOWN button subtract one second from countdown timer
- BACK button round timer to nearest minute down 
- START button start/stop countdown
After countdown ends, app will automatically add one lap (if activity is recording) and will switch back to *Cruise* mode.
To manually exit back to *Cruise* mode, press and hold UP button (over 2 sec.) 

if you create .txt file named after the app in APPS\LOG directory of your garmin, you'll see lap statistic there after app usage: lap time, max speed, avg speed and distance covered
