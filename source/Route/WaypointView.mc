using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Math as Math;

class WaypointView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _waypointViewDc;
	hidden var _routeTrack;
	 
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
    	var currentRoute = Settings.CurrentRoute;
    	if (currentRoute == null)
    	{
    		Sys.println("there is no active route");
    		return;
    	}
        _routeTrack = new RouteTrack(currentRoute);
        
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    	
		Sys.println(currentRoute["RouteId"]);
		Sys.println(currentRoute["RouteName"]);
		Sys.println(currentRoute["RouteDate"]);
		
		var lat1 = currentRoute["WayPoints"][0]["Lat"].toFloat();
		var lon1 = currentRoute["WayPoints"][0]["Lon"].toFloat();
		var lat2 = currentRoute["WayPoints"][1]["Lat"].toFloat();
		var lon2 = currentRoute["WayPoints"][1]["Lon"].toFloat();
		
		Sys.println("lat1 : " + lat1);
		Sys.println("lon1 : " + lon1);
		Sys.println("lat2 : " + lat2);
		Sys.println("lon2 : " + lon2);		
		
		var gpsInfo = _gpsWrapper.GetGpsInfo();
		var geoCalc = _routeTrack;
		
	
		var geoDistance = geoCalc.GetDistance(Math.toRadians(lat1), Math.toRadians(lon1), Math.toRadians(lat2), Math.toRadians(lon2));
		var geoBearing = geoCalc.GetBearing(Math.toRadians(lat1), Math.toRadians(lon1), Math.toRadians(lat2), Math.toRadians(lon2));
		Sys.println("geo bearing: " + geoBearing);
		Sys.println("geo distance: " + geoDistance + " m, " + geoDistance / _gpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
		
		var xte2 = geoCalc.getXte(
			Math.toRadians(18.35585066137293), Math.toRadians(-38.08834475672381), 
			Math.toRadians(18.35585066137293), Math.toRadians(-20.35775407416596),
			Math.toRadians(9.987217572513453), Math.toRadians(-38.04593696104232));
		Sys.println("xte2: " + xte2 +" m, " + xte2 / _gpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
		
		var xte3 = geoCalc.getXte(Math.toRadians(0), Math.toRadians(0), Math.toRadians(2), Math.toRadians(0), Math.toRadians(0), Math.toRadians(1));
		Sys.println("xte3: " + xte3 +" m, " + xte3 / _gpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
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
			
			// route data
			//
			var inRouteInfo = _routeTrack.GetInRouteInfo(gpsInfo);
			
			_waypointViewDc.PrintVmg(dc, inRouteInfo.Vmg);
			_waypointViewDc.PrintBearing(dc, inRouteInfo.Bearing);
			_waypointViewDc.PrintDistance2Wp(dc, inRouteInfo.Distance2Wp);
			_waypointViewDc.PrintDistance2Finish(dc, inRouteInfo.Distance2Finish);
			_waypointViewDc.PrintXte(dc, inRouteInfo.Xte);
			_waypointViewDc.PrintDistanceCovered(dc, gpsInfo.TotalDistance);
        }
        
        // Display current state
    	//
        var clockTime = Sys.getClockTime();        
        _waypointViewDc.PrintTime(dc, clockTime);
        _waypointViewDc.DisplayState(dc, 
        	gpsInfo.Accuracy, gpsInfo.IsRecording, _routeTrack.CurrentWayPoint(), _routeTrack.TotalWayPoints());
        _waypointViewDc.DrawGrid(dc);
    }
    
    function SkipWayPoint()
    {
    	_routeTrack.SkipWayPoint();
    }
}