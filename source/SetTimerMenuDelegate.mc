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
		
		Ui.popView(Ui.SLIDE_RIGHT);
    }
}