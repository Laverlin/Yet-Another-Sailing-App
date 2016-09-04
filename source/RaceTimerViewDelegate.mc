using Toybox.WatchUi as Ui;

class RaceTimerViewDelegate extends Ui.BehaviorDelegate 
{
    hidden var _raceTimerView;
    
    function initialize(raceTimerView) 
    {
        BehaviorDelegate.initialize();
        _raceTimerView = raceTimerView;
    }    
    
    function onSelect()
    {
    	_raceTimerView.StartStopCountdown();
    	return true;
    }

    function onMenu() 
    {
        Ui.popView(Ui.SLIDE_LEFT);
        return true;
    }
    

}