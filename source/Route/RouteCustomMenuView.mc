using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

class RouteCustomMenuView extends Ui.View 
{

    hidden var _routeCustomMenuViewDc;
    hidden var _currentSelection;


	function initialize(routeCustomMenuViewDc) 
    {
        View.initialize();

        _routeCustomMenuViewDc = routeCustomMenuViewDc;
	}

    function onShow()
    {
		if (Settings.CurrentRoute != null)
		{
			_currentSelection = :start;
		}
		else
		{
			_currentSelection = :load;
		}
    }

    function onUpdate(dc) 
    {   
    	var actualRoute = Settings.CurrentRoute;
    
        _routeCustomMenuViewDc.ClearDc(dc);
        
        if (actualRoute != null)
        {
        	_routeCustomMenuViewDc.PrintActualRoute(dc, actualRoute, _currentSelection);
        }
	
		_routeCustomMenuViewDc.PrintLoadRoute(dc, _currentSelection);
	}
	
	function ChangeSelection()
	{
		_currentSelection = (_currentSelection == :start) ? :load : :start;
        Ui.requestUpdate();
	}
	
	function GetCurrentSelection()
	{
		return _currentSelection;
	}

}