using Toybox.WatchUi as Ui;

class IBSailingCruiseDelegate extends Ui.BehaviorDelegate 
{
	hidden var _cruiseView;
	
    function initialize(cruiseView) 
    {
        BehaviorDelegate.initialize();
        _cruiseView = cruiseView;
    }
    
    function onSelect()
    {
    	_cruiseView.StartStopActivity();
    	return true;
    }

    function onMenu() 
    {
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        Ui.pushView(new Rez.Menus.BackMenu(), new IBBackMenuDelegate(_cruiseView), Ui.SLIDE_UP);
        return true;
    }
}