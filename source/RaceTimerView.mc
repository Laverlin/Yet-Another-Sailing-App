using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _countdown = 60.0;
	hidden var _isCountdown = false;
	hidden var _lastTimer = 0l;

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
    	if (_isCountdown)
        {
        	var actualTimer = Sys.getTimer();
        	_countdown -= ((actualTimer - _lastTimer).toDouble() / 1000);
        	_lastTimer = actualTimer;        	
        	
        	if (_countdown <= 0)
        	{
        		Sys.println(_lastTimer);
        		
        		SignalWrapper.Start();
        		Ui.popView(Ui.SLIDE_LEFT);
        	}
        	
        	if (_countdown.toLong() % 30 == 0)
        	{
        		SignalWrapper.HalfMinute();
        	}
        	
        	if (_countdown < 11)
        	{
        		SignalWrapper.TenSeconds(_countdown.toLong());
        	}
        }
        
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {
    	RaceTimerViewDc.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        RaceTimerViewDc.PrintTime(dc, clockTime);
        RaceTimerViewDc.PrintCountdown(dc, _countdown.toLong());
    }
    
    function StartStopCountdown()
    {
    	SignalWrapper.PressButton();
    	_isCountdown = !_isCountdown;
    	if (_isCountdown)
    	{
    		_lastTimer = Sys.getTimer();
    		_timer.stop();
    		_timer.start(method(:onTimerUpdate), 1000, true);
    		Ui.requestUpdate();
    		Sys.println(_lastTimer);
    	}
    }
    
    function AddOneSec()
    {
    	_countdown +=1;
    	Ui.requestUpdate();
    }
    
    function SubOneSec()
    {
    	_countdown -=1;
    	Ui.requestUpdate();
    }
    
    function DownToMinute()
    {
    	_countdown = _countdown.toLong() / 60 * 60;
    	Ui.requestUpdate();
    }
}