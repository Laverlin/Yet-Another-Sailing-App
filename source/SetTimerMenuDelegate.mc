using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetTimerMenuDelegate extends Ui.MenuInputDelegate
{
	function initialize() 
    {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
		var timerValue = item.toNumber() * 60;  
		Settings.TimerValue = timerValue;
		Ui.popView(Ui.SLIDE_RIGHT);
    }
}