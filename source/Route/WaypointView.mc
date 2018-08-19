using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

class WaypointView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _waypointViewDc;
	hidden var _waypoint;
	hidden var _currentWayPoint = 1;
	hidden var _totalWayPoints;

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
    	
		var currentRoute = Settings.CurrentRoute;
		_totalWayPoints = currentRoute["WayPoints"].size();
		
		Sys.println(currentRoute["RouteId"]);
		Sys.println(currentRoute["RouteName"]);
		Sys.println(currentRoute["RouteDate"]);
		Sys.println(_totalWayPoints);
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
			_waypointViewDc.PrintBearing(dc, gpsInfo.BearingDegree);
			_waypointViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
			//_waypointViewDc.PrintBearing(dc, gpsInfo.Bearing);
        }
        
        // Display current state
    	//
        var clockTime = Sys.getClockTime();        
        _waypointViewDc.PrintTime(dc, clockTime);
        _waypointViewDc.DisplayState(dc, gpsInfo.Accuracy, gpsInfo.IsRecording, _currentWayPoint, _totalWayPoints);
        _waypointViewDc.DrawGrid(dc);
    }
}