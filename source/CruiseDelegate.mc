using Toybox.WatchUi as Ui;

class CruiseDelegate extends Ui.BehaviorDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    
    function initialize(cruiseView, gpsWrapper) 
    {
        BehaviorDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
    }    
    
    function onSelect()
    {
    	_cruiseView.StartStopActivity();
    	return true;
    }

    function onMenu() 
    {
        Ui.pushView(new Rez.Menus.CruiseMenu(), new CruiseMenuDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        _cruiseView.AddLap();
        return true;
    }
}