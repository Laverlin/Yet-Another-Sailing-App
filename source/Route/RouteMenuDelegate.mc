using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// Route menu handler
//
class RouteMenuDelegate extends Ui.MenuInputDelegate 
{
 	hidden var _waypointView;
 	hidden var _selectRouteView;
 	hidden var _gpsWrapper;
 	hidden var _stubRouteViewDc;
 
    function initialize(waypointView, selectRouteView, gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _waypointView = waypointView;
        _selectRouteView = selectRouteView;
        _gpsWrapper = gpsWrapper;
        _stubRouteViewDc = null;
    }

    function onMenuItem(item) 
    {
        if (item == :startRoute)
        {
            Ui.pushView(_waypointView, new WaypointViewDelegate(_waypointView, _gpsWrapper), Ui.SLIDE_RIGHT);
        } 
        else if (item == :selectRoute)
        {
			Ui.pushView(new StubRouteView(_stubRouteViewDc), null, Ui.SLIDE_RIGHT);
        }  
    }
}

class StubRouteView extends Ui.View 
{
	hidden var _stubRouteViewDc;
	hidden var _mainMenuDelegate;
	
    function initialize(stubRouteViewDc) 
    {
        View.initialize();
		_stubRouteViewDc = stubRouteViewDc;
    }

    // Load List of available routes
    //
    function onShow() 
    {
        var selectRouteMenu = [
        	new DMenuItem (:route1, "Route 1", "some suggestion text", null),
			new DMenuItem (:route2, "Route 2", "some other text", null)];
	
		var view = new DMenu (selectRouteMenu, "Routes");
		var viewDelegate =  new DMenuDelegate (view, null);
    
		Ui.pushView(view, viewDelegate, Ui.SLIDE_IMMEDIATE);
    }
}


