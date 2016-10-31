using Toybox.WatchUi as Ui;

class CruiseViewDelegate extends Ui.BehaviorDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _raceTimerView;
    hidden var _cruiseMenuDelegate;
    
    function initialize(cruiseView, gpsWrapper) 
    {
        BehaviorDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
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
        Ui.popView(Ui.SLIDE_RIGHT);
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