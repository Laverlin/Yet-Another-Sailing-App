using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

(:savememory)
class RouteCustomMenuView extends Ui.View 
{
	hidden var _gpsWrapper;
    hidden var _routeCustomMenuViewDc;
    hidden var _waypointView;
    hidden var _selectRouteView;
    
    hidden var _selection;
    hidden var _isInSelection = false;

	function initialize(gpsWrapper, routeCustomMenuViewDc, waypointView, selectRouteView) 
    {
        View.initialize();

		_gpsWrapper = gpsWrapper;
        _routeCustomMenuViewDc = routeCustomMenuViewDc;
        _waypointView = waypointView;
        _selectRouteView = selectRouteView;
	}

    function onShow()
    {
		if (Settings.CurrentRoute != null)
		{
			_selection = :start;
		}
		
		// if there is no any routes - push to choose one
		// but if back button was pressed and no route were selected, then needs to pop one level up
		// that's why _isInSelection flag is needed. 
		//
		else if (!_isInSelection)
		{
			_isInSelection = true;
			Ui.pushView(_selectRouteView, new SelectRouteViewDelegate(_selectRouteView), Ui.SLIDE_RIGHT);
		}
		else
		{
			_isInSelection = false;
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		}
    }

    function onUpdate(dc) 
    {   
    	var actualRoute = Settings.CurrentRoute;
    
        _routeCustomMenuViewDc.ClearDc(dc);
        
        if (actualRoute != null)
        {
        	_routeCustomMenuViewDc.PrintActualRoute(dc, actualRoute, _selection);
        }
        else
        {
        	_routeCustomMenuViewDc.PrintNoRoute(dc);
        }
	
		_routeCustomMenuViewDc.PrintLoadRoute(dc, _selection);
	}
	
	function ChangeSelection()
	{
		if (Settings.CurrentRoute != null)
		{
			_selection = (_selection == :start) ? :load : :start;
        	Ui.requestUpdate();
        }
	}
	
 	function PushSelectedView()
 	{
 	    if (_selection == :start)
    	{
    		Ui.pushView(_waypointView, new WaypointViewDelegate(_waypointView, _gpsWrapper), Ui.SLIDE_RIGHT);
    	}
    	if (_selection == :load)
    	{
    		Ui.pushView(_selectRouteView, new SelectRouteViewDelegate(_selectRouteView), Ui.SLIDE_RIGHT);
    	}
 	}
}