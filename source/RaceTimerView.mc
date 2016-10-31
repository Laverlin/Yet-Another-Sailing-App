using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
    hidden var _cruiseView;
    hidden var _raceTimerViewDc;
	hidden var _timer = new Timer.Timer();
	hidden var _timerValue = 0;
	hidden var _isTimerRun = false;

    function initialize(gpsWrapper, cruiseView, raceTimerViewDc) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
        _cruiseView = cruiseView;
        _raceTimerViewDc = raceTimerViewDc;
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
    	_timer.start(method(:onTimerUpdate), 1000, true);
    	if (_timerValue <= 0)
    	{
    		_timerValue = Settings.TimerValue;
    	}
    }

    // Stop timer then hide
    //
    function onHide() 
    {
    	_isTimerRun =false;
        _timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate()
    {
    	if (_isTimerRun)
        {
        	_timerValue -= 1;
        	
        	if (_timerValue <= 0)
        	{
        		SignalWrapper.Start();
        		_gpsWrapper.AddLap();
        		Ui.switchToView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_LEFT);
        		return;
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
    	_raceTimerViewDc.ClearDc(dc);
    
    	// display progress
    	//
    	_raceTimerViewDc.DrawProgress(dc, _timerValue.toLong());

		_raceTimerViewDc.PrintCountdown(dc, _timerValue.toLong());
		
        var clockTime = Sys.getClockTime();        
        _raceTimerViewDc.PrintTime(dc, clockTime);

        var gpsInfo = _gpsWrapper.GetGpsInfo();
        _raceTimerViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
        
        //RaceTimerViewDc.PrintTips(dc);
    }
    
    function StartStopCountdown()
    {
    	SignalWrapper.PressButton();
    	_isTimerRun = !_isTimerRun;
    	if (_isTimerRun)
    	{
    		_timer.stop();
    		_timer.start(method(:onTimerUpdate), 1000, true);
    		Ui.requestUpdate();
    	}
    }
    
    function AddOneSec()
    {
    	_timerValue += 1;
    	Ui.requestUpdate();
    }
    
    function SubOneSec()
    {
    	_timerValue -= 1;
    	Ui.requestUpdate();
    }
    
    function DownToMinute()
    {
    	_timerValue = _timerValue.toLong() / 60 * 60;
    	Ui.requestUpdate();
    }
}