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
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(_cruiseView), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        _cruiseView.AddLap();
        //Ui.pushView(new Rez.Menus.BackMenu(), new IBBackMenuDelegate(_cruiseView), Ui.SLIDE_UP);
        return true;
    }
}