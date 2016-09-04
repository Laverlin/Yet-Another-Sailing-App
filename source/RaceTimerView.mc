using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _countdown = 300;
	hidden var _isCountdown = false;
	hidden var _countdownTimer = 0l;

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
        if (_isCountdown)
        {
        	var actualTimer = Sys.getTimer();
        	_countdown -= (actualTimer - _countdownTimer) / 1000;
        	_countdownTimer = actualTimer;
        }   
    
    	RaceTimerViewDc.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        RaceTimerViewDc.PrintTime(dc, clockTime);
        RaceTimerViewDc.PrintCountdown(dc, _countdown);

    }
    
    function StartStopCountdown()
    {
    	_isCountdown = !_isCountdown;
    	if (_isCountdown)
    	{
    		_countdownTimer = Sys.getTimer();
    		_timer.stop();
    		_timer.start(method(:onTimerUpdate), 1000, true);
    		Ui.requestUpdate();
    	}
    }
}