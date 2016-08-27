using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;

class LapView extends Ui.View 
{
	function initialize() 
    {
        View.initialize();

    }

    function onShow() 
    {

    }

    function onHide() 
    {

    }

    function onUpdate(dc) 
    {   
    	var currentLap = _gpsWrapper.GetLap(_currentLapNum);
    	
    	
    }
}