using Toybox.WatchUi as Ui;

// Custom menu to choose - start to track route or load available routes and choose one
//
(:savememory)
class RouteCustomMenuDelegate extends Ui.BehaviorDelegate 
{
	hidden var _routeCustomMenuView;
	
    function initialize(routeCustomMenuView) 
    {
        BehaviorDelegate.initialize();
		_routeCustomMenuView = routeCustomMenuView;
    }
    
    function onMenu()
    {
    	Ui.popView(Ui.SLIDE_IMMEDIATE);
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
    	_routeCustomMenuView.PushSelectedView();
    	return true;
    }
    
    function onBack()
    {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
    }
}