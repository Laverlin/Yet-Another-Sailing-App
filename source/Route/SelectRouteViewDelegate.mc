using Toybox.WatchUi as Ui;

class SelectRouteViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _selectRouteView;

	
    function initialize(selectRouteView) 
    {
        BehaviorDelegate.initialize();
		_selectRouteView = selectRouteView;
    }
    
    function onMenu()
    {
    	Ui.popView(Ui.SLIDE_RIGHT);
    }
    
    function onNextPage()
    {
    	_selectRouteView.NextRoute();

    	return true;
    }

    function onPreviousPage()
    {
    	_selectRouteView.PreviousRoute();
      
        return true;
    }
    
    function onSelect()
    {
		_selectRouteView.RouteSelected();
    	return true;
    }
    
    function onBack()
    {
		Ui.popView(Ui.SLIDE_RIGHT);
		return true;
    }
    
}