using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// Route menu handler
//
class RouteMenuDelegate extends Ui.MenuInputDelegate 
{
 	hidden var _waypointView;
 	hidden var _selectRouteView;
 	hidden var _gpsWrapper;
 
    function initialize(waypointView, selectRouteView, gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _waypointView = waypointView;
        _selectRouteView = selectRouteView;
        _gpsWrapper = gpsWrapper;
    }

    function onMenuItem(item) 
    {
        if (item == :startRoute)
        {
            Ui.pushView(_waypointView, new WaypointViewDelegate(_waypointView, _gpsWrapper), Ui.SLIDE_RIGHT);
        } 
        else if (item == :selectRoute)
        {
			Ui.pushView(_selectRouteView, null, Ui.SLIDE_RIGHT);
        }  
    }
}
