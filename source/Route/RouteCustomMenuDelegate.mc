using Toybox.WatchUi as Ui;

class RouteCustomMenuDelegate extends Ui.BehaviorDelegate 
{
	hidden var _routeCustomMenuView;
	hidden var _selectRouteView;
	hidden var _waypointView;
	hidden var _gpsWrapper;
	
	
    function initialize(gpsWrapper, routeCustomMenuView, waypointView, selectRouteView) 
    {
        BehaviorDelegate.initialize();
		_routeCustomMenuView = routeCustomMenuView;
		_selectRouteView = selectRouteView;
		_waypointView = waypointView;
		_gpsWrapper = gpsWrapper;
    }
    
    function onMenu()
    {
    	Ui.popView(Ui.SLIDE_RIGHT);
    }
    
    function onNextPage()
    {
    	_routeCustomMenuView.ChangeSelection();

    	return true;
    }

    function onPreviousPage()
    {
    	_routeCustomMenuView.ChangeSelection();
      
        return true;
    }
    
    function onSelect()
    {
    	var currentSelection = _routeCustomMenuView.GetSelection();
    	if (currentSelection == :start)
    	{
    		Ui.pushView(_waypointView, new WaypointViewDelegate(_waypointView, _gpsWrapper), Ui.SLIDE_RIGHT);
    	}
    	if (currentSelection == :load)
    	{
    		Ui.pushView(_selectRouteView, new SelectRouteViewDelegate(_selectRouteView), Ui.SLIDE_RIGHT);
    	}
    	return true;
    }
    
    function onBack()
    {
		Ui.popView(Ui.SLIDE_RIGHT);
		return true;
    }
}