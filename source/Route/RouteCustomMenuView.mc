using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

class RouteCustomMenuView extends Ui.View 
{
    hidden var _routeCustomMenuViewDc;
    hidden var _selection;

	function initialize(routeCustomMenuViewDc) 
    {
        View.initialize();

        _routeCustomMenuViewDc = routeCustomMenuViewDc;
	}

    function onShow()
    {
		if (Settings.CurrentRoute != null)
		{
			_selection = :start;
		}
		else
		{
			_selection = :load;
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
	
	function GetSelection()
	{
		return _selection;
	}
}