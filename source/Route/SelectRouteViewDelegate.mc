using Toybox.WatchUi as Ui;

(:savememory)
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
    	Ui.popView(Ui.SLIDE_IMMEDIATE);
    	return true;
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
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
    }
    
}