using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;

    function initialize(gpsWrapper) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    }

    // Stop timer then hide
    //
    function onHide() 
    {
        _timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate()
    {
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {   
    	DcWrapper.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        DcWrapper.PrintTime(dc, clockTime);
    }
}