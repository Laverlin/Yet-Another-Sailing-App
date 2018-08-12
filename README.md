# Yet-Another-Sailing-App

### supported devices

Fenix 3 [HR] / Quatix 3 / Tactix Bravo / D2 / D2 Titanum /
Fenix 5 [Plus] / Fenix 5X [Plus] / Quatix 5 / Fenix 5S Plus/ Tactix Charlie /
Forerunner 935

### install

https://apps.garmin.com/en-US/apps/159028ac-590b-4836-a1e2-474d248469c5

### feedback 

https://forums.garmin.com/forum/developers/connect-iq/connect-iq-showcase/1383630-app-yet-another-sailing-app 

### description

There are a few nice sailing apps already, but this is yet another one... =)   

This app has 
- Race Timer with ISAF starting sequence support 
- Cruise view with speed, bearing and other valuable data
- Laps view 

In **Cruise** mode you may see at one glance, actual speed, bearing, max speed and avg speed for last 10 seconds. Also, there are set of helpful indicators, like GPS status, recording status and actual speed vs avg speed, which is very useful for sail trimming.
Moving average of bearing for last 10 sec. could be helpful in long-distance cruise.   

In **Race Timer** mode you may see remaining seconds till start, actual time and speed. You can also adjust countdown timer by one sec up and down, and down to next minute.

In **Laps view** you may see data - max speed, average speed, distance and time for last 20 laps  

Waypoint mode is under development.

### usage

- In any view press and hold UP (over 2 sec.) to get access to main menu.    
	In main menu you may choose   
   -- switch to *Race Timer* mode  
   -- switch to *Cruise* mode   
   -- switch to *Laps view*  
   -- change settings: initialize countdown value for Race Timer, change Background Color and enable/disable Auto recording  

In **Cruise** mode     
- press start/stop button to start/stop recording. This option available only if GPS signal strong enough (gps indicator yellow or green)
- press back button to add new lap. Laps statistic available in *Laps View*.  
 
In **Race Timer** mode   
- UP add one second to countdown timer
- DOWN subtract one second from countdown timer
- BACK round timer to nearest minute down 
- START start/stop countdown
After countdown ends, app will automatically add one lap (if activity is recording) and switch to *Cruise* mode.

In **Laps View** you can see data from last 20 laps. This data stores permanently, even if you close the app and start it again, laps data will be on place  
- UP shows previous lap
- DOWN scroll to next lap
- BACK offer you to clear all laps from permanent storage and drop lap counter to zero.  

### Changelog

**version 0.71**
- add Fenix 5S Plus support (Fenix 5S does not supported yet)

**version 0.70**
- add support  D2 / D2 Titanum / Fenix 5 [Plus] / Fenix 5X [Plus] / Quatix 5 / ForeRunner 935 / Tactix Charlie

**version 0.67**
- fix set timer issue: it was needed to reload app after init countdown timer 
- race timer will pop out automatically, after new countdown timer initialization

**version 0.66**
- set main menu as a default view from start 
 
**version 0.65** 
- display distance covered in cruise mode 
- change layout in cruise mode
- max speed calculated as moving average for 3 sec, to avoid fluctuation 
  
**version 0.6**
- color countdown progress bar   
- new main menu   
- permanently stored laps   
   
**version 0.5**  
- add Race Timer   
- fix view issues   
   
**version 0.21**   
- minor change in UI   
