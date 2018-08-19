using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Math as Math;

class WaypointView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _waypointViewDc;
	hidden var _waypoint;
	hidden var _currentWayPoint = 0;
	hidden var _totalWayPoints;
	hidden var _currentRoute;
	hidden var _lastKnownDistance2Wp = 0; 
	hidden var _currentDistance2Wp = 0;
	
	hidden const EARTH_RADIUS_M = 6378137;
	hidden const METERS_PER_NAUTICAL_MILE = 1852;
    hidden const MS_TO_KNOT = 1.9438444924574;

    function initialize(gpsWrapper, waypointViewDc) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
        _waypointViewDc = waypointViewDc;
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    	
		_currentRoute = Settings.CurrentRoute;
		_totalWayPoints = _currentRoute["WayPoints"].size();
		
		Sys.println(_currentRoute["RouteId"]);
		Sys.println(_currentRoute["RouteName"]);
		Sys.println(_currentRoute["RouteDate"]);
		Sys.println(_totalWayPoints);
		
		var lat1 = _currentRoute["WayPoints"][0]["Lat"].toFloat();
		var lon1 = _currentRoute["WayPoints"][0]["Lon"].toFloat();
		var lat2 = _currentRoute["WayPoints"][1]["Lat"].toFloat();
		var lon2 = _currentRoute["WayPoints"][1]["Lon"].toFloat();
		
		Sys.println("lat1 : " + lat1);
		Sys.println("lon1 : " + lon1);
		Sys.println("lat2 : " + lat2);
		Sys.println("lon2 : " + lon2);		
		
		var distance = getDistance(lat1, lon1, lat2, lon2);
		
		Sys.println(distance/METERS_PER_NAUTICAL_MILE);
    }

    // Stop timer then hide
    //
    function onHide() 
    {
        _timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate()
    {
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {   
    	_waypointViewDc.ClearDc(dc);
        
        // Display speed and bearing if GPS available
        //
        var gpsInfo = _gpsWrapper.GetGpsInfo();
        if (gpsInfo.Accuracy > 0)
        {
        	// boat data
        	//
			_waypointViewDc.PrintCog(dc, gpsInfo.BearingDegree);
			_waypointViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
			
			//
			//
			calculateDiff(gpsInfo);
			_waypointViewDc.PrintVmg(dc, getVmg());
        }
        
        // Display current state
    	//
        var clockTime = Sys.getClockTime();        
        _waypointViewDc.PrintTime(dc, clockTime);
        _waypointViewDc.DisplayState(dc, gpsInfo.Accuracy, gpsInfo.IsRecording, _currentWayPoint, _totalWayPoints);
        _waypointViewDc.DrawGrid(dc);
    }
    
    function getVmg()
    {
    	return (_lastKnownDistance2Wp - _currentDistance2Wp) * MS_TO_KNOT;
    }
    
    function getDistance2Wp()
    {
    	return _currentDistance2Wp;
    }
    
    function calculateDiff(gpsInfo)
    {
     	var wpLat = _currentRoute["WayPoints"][_currentWayPoint]["Lat"].toFloat();
    	var wpLon = _currentRoute["WayPoints"][_currentWayPoint]["Lon"].toFloat();
    	var gpsLocation = gpsInfo.GpsLocation.toDegrees();
    	var gpsLat = gpsLocation[0];
    	var gpsLon = gpsLocation[1];
    	
  		var distance = getDistance(wpLat, wpLon, gpsLat, gpsLon);  

  		_lastKnownDistance2Wp = _currentDistance2Wp;  	
    	_currentDistance2Wp = distance;
    }
    
    function getDistance(lat1, lon1, lat2, lon2)
    {
    	var LatDiff = Math.toRadians(lat2 - lat1);
  		var LonDiff = Math.toRadians(lon2 - lon1);
  		var lat1Rad = Math.toRadians(lat1);
  		var lat2Rad = Math.toRadians(lat2);

  		var a = Math.pow(Math.sin(LatDiff/2), 2) +
  				Math.pow(Math.sin(LonDiff/2), 2) * Math.cos(lat1Rad) * Math.cos(lat2Rad);
  				
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 

  		var distance = EARTH_RADIUS_M * c;
  		return distance;
    }
}