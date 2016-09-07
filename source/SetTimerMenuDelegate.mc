using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetTimerMenuDelegate extends Ui.MenuInputDelegate
{
    hidden var _raceTimerView;

	function initialize(raceTimerView) 
    {
        MenuInputDelegate.initialize();
        _raceTimerView = raceTimerView;
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetTimerValue(60);
    	}  
    	else if (item == :id2)
    	{
    		Settings.SetTimerValue(120);
    	}
    	else if (item == :id3)
    	{
    		Settings.SetTimerValue(180);
    	}
    	else if (item == :id4)
    	{
    		Settings.SetTimerValue(240);
    	}
    	else if (item == :id5)
    	{
    		Settings.SetTimerValue(300);
    	}    	
        else if (item == :id10)
        {
            Settings.SetTimerValue(600);
        }    
        else if (item == :id20)
        {
            Settings.SetTimerValue(1200);
        }    
        else if (item == :id30)
        {
            Settings.SetTimerValue(1800);
        }    
        else if (item == :id40)
        {
            Settings.SetTimerValue(2400);
        }    
        else if (item == :id50)
        {
            Settings.SetTimerValue(3000);
        } 
        else if (item == :id60)
        {
            Settings.SetTimerValue(3600);
        } 
		
		Ui.switchToView(_raceTimerView, new RaceTimerViewDelegate(_raceTimerView), Ui.SLIDE_RIGHT);
    }
}