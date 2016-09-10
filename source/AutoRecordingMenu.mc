using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class AutoRecordingMenuDelegate extends Ui.MenuInputDelegate 
{
    function initialize() 
    {
        MenuInputDelegate.initialize();
    }
    
    function onMenuItem(item) 
    {
    	if (item == :isAutoOn)
    	{
    		Settings.SetAutoRecording(true);
    	}
    	else if (item == :isAutoOff)
    	{
    		Settings.SetAutoRecording(false);
    	}
    	
    	Ui.popView(Ui.SLIDE_LEFT);
    }
}