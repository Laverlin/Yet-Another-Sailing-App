using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _timerValue = 300.0;
	hidden var _isTimerRun = false;
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
    	_timerValue = Settings.TimerValue;
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
    	if (_isTimerRun)
        {
        	var actualTimer = Sys.getTimer();
        	_timerValue -= 1;//((actualTimer - _lastTimer).toDouble() / 1000);
        	_lastTimer = actualTimer;        	
        	
        	if (_timerValue <= 0)
        	{
        		Sys.println(_lastTimer + "- end");
        		
        		SignalWrapper.Start();
        		_gpsWrapper.AddLap();
        		SignalWrapper.StartEnd();
        		Ui.popView(Ui.SLIDE_LEFT);
        	}
        	
        	if (_timerValue.toLong() % 30 == 0)
        	{
        		SignalWrapper.HalfMinute();
        	}
        	
        	if (_timerValue < 11)
        	{
        		SignalWrapper.TenSeconds(_timerValue.toLong());
        	}
        }
        
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {
    	RaceTimerViewDc.ClearDc(dc);
    
    	// display progress
    	//
    	RaceTimerViewDc.DrawProgress(dc, _timerValue.toLong());

		RaceTimerViewDc.PrintCountdown(dc, _timerValue.toLong());
		
        var clockTime = Sys.getClockTime();        
        RaceTimerViewDc.PrintTime(dc, clockTime);

        var gpsInfo = _gpsWrapper.GetGpsInfo();
        RaceTimerViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
    }
    
    function StartStopCountdown()
    {
    	SignalWrapper.PressButton();
    	_isTimerRun = !_isTimerRun;
    	if (_isTimerRun)
    	{
    		_lastTimer = Sys.getTimer();
    		_timer.stop();
    		_timer.start(method(:onTimerUpdate), 1000, true);
    		Ui.requestUpdate();
    		Sys.println(_lastTimer + "- begin");
    	}
    }
    
    function AddOneSec()
    {
    	_timerValue +=1;
    	Ui.requestUpdate();
    }
    
    function SubOneSec()
    {
    	_timerValue -=1;
    	Ui.requestUpdate();
    }
    
    function DownToMinute()
    {
    	_timerValue = _timerValue.toLong() / 60 * 60;
    	Ui.requestUpdate();
    }
}