using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Math as Math;
using Toybox.Test as Test;

(:savememory)
class WaypointView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _waypointViewDc;
	hidden var _routeTrack;
	hidden var _gpsInfo;
	hidden var _routeInfo;
	hidden var _cruiseView; 
	 
    function initialize(gpsWrapper, waypointViewDc, cruiseView) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
        _waypointViewDc = waypointViewDc;
        _cruiseView = cruiseView;
        _timer = new Toybox.Timer.Timer();
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
    	var currentRoute = Settings.CurrentRoute;
    	if (currentRoute == null)
    	{
    		//Sys.println("there is no active route");
            // Ui.popView(Ui.SLIDE_IMMEDIATE);
    		return;
    	}
        _routeTrack = new RouteTrack(currentRoute);

    	_timer.start(method(:onTimerUpdate), 1000, true);
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
    	if (_routeTrack.GetIsRouteFinished())
    	{
        	Ui.popView(Ui.SLIDE_IMMEDIATE);
        	Ui.popView(Ui.SLIDE_IMMEDIATE);
        	Ui.pushView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_IMMEDIATE);
    	}
    	
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {   
        // if set to switch to the Route mode after RaceTimer finished
        // here is the only point to check if the Route is set and rollback if not
        //
        if (_routeTrack == null)
        {
            Ui.popView(Ui.SLIDE_IMMEDIATE);
            return;
        }

    	_waypointViewDc.ClearDc(dc);
        
        // Display current state
    	//
        var clockTime = Sys.getClockTime();
        var gpsInfo = _gpsWrapper.GetGpsInfo();
        _waypointViewDc.PrintTime(dc, clockTime);
        _waypointViewDc.DisplayState(dc, 
        	gpsInfo.Accuracy, gpsInfo.IsRecording, _routeTrack.GetCurrentWayPoint(), _routeTrack.TotalWayPoints());
        
        _waypointViewDc.DrawGrid(dc);
        
        // Display speed and bearing if GPS available
        //
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
			
			_waypointViewDc.DisplayDirection2Wp(dc, gpsInfo.BearingDegree, inRouteInfo.Bearing);
        }
        
    }
    
    function NextWayPoint()
    {
    	_routeTrack.NextWayPoint();
    }
    
    function PrevWayPoint()
    {
        _routeTrack.PrevWayPoint();
    }
}