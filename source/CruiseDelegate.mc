using Toybox.WatchUi as Ui;

class CruiseDelegate extends Ui.BehaviorDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _dcWrapper;
    
    function initialize(cruiseView, gpsWrapper, dcWrapper) 
    {
        BehaviorDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
        _dcWrapper = dcWrapper;
    }    
    
    function onSelect()
    {
    	_cruiseView.StartStopActivity();
    	return true;
    }

    function onMenu() 
    {
        Ui.pushView(new Rez.Menus.CruiseMenu(), new CruiseMenuDelegate(_cruiseView, _gpsWrapper, _dcWrapper), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        _cruiseView.AddLap();
        return true;
    }
}