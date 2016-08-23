using Toybox.WatchUi as Ui;

class CruiseDelegate extends Ui.BehaviorDelegate 
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
        Ui.pushView(new Rez.Menus.CruiseMenu(), new CruiseMenuDelegate(_cruiseView), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        _cruiseView.AddLap();
        return true;
    }
}