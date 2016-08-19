using Toybox.WatchUi as Ui;

class IBSailingCruiseDelegate extends Ui.BehaviorDelegate 
{
	hidden var _handlerView;
	
	function setHandlerView(handlerView)
	{
		_handlerView = handlerView;
	}

    function initialize() 
    {
        BehaviorDelegate.initialize();
    }
    
    function onSelect()
    {
    	_handlerView.StartStopActivity();
    	return true;
    }

    function onMenu() 
    {
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        Ui.pushView(new Rez.Menus.BackMenu(), new IBBackMenuDelegate(_handlerView), Ui.SLIDE_UP);
        return true;
    }
}