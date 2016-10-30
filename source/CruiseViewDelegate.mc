using Toybox.WatchUi as Ui;

class CruiseViewDelegate extends Ui.BehaviorDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _raceTimerView;
    
    function initialize(cruiseView, raceTimerView, gpsWrapper) 
    {
        BehaviorDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
        _raceTimerView = raceTimerView;
    }    
    
    function onSelect()
    {
        // if recording available, make sound
        //
    	if (_gpsWrapper.StartStopRecording())
        {
            SignalWrapper.PressButton();
        }
    	return true;
    }

    function onMenu() 
    {
        Ui.pushView(new Rez.Menus.CruiseMenu(), new CruiseMenuDelegate(_cruiseView, _raceTimerView, _gpsWrapper), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack()
    {
        // if lap successfully added, make sound
        //
        if (_gpsWrapper.AddLap())
        {
            SignalWrapper.PressButton();
        }
        return true;
    }
    
    function onNextPage()
    {
    	_cruiseView.SwitchNextMode();
    }
}