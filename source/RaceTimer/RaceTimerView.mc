using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;
using Toybox.Timer as T;

class RaceTimerView extends Ui.View 
{
    hidden var _gpsWrapper;
    hidden var _cruiseView;
    hidden var _waypointView;
    hidden var _raceTimerViewDc;
	hidden var _timer; 
	hidden var _timerValue = 0;
	hidden var _isTimerRun = false;

    function initialize(gpsWrapper, cruiseView, waypointView, raceTimerViewDc) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
        _cruiseView = cruiseView;
        _waypointView = waypointView;
        _raceTimerViewDc = raceTimerViewDc;
        _timer = new T.Timer();
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
        if (!_isTimerRun) 
        {
            _timer.stop();
            _timer.start(method(:onTimerUpdate), 1000, true);
            if (_timerValue <= 0 || Settings.IsTimerValueUpdated)
            {
                _timerValue = Settings.GetTimerValue();
            }
        }
    }

    function stopTimer()
    {
        _timer.stop();
        _isTimerRun = false;
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
                stopTimer();
        		SignalWrapper.Start();
        		_gpsWrapper.AddLap();
                if (Settings.TimerSuccessor == Settings.Cruise)
                {
        		    Ui.switchToView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_LEFT);
                }
                else 
                {
                    Ui.switchToView(_waypointView, new WaypointViewDelegate(_waypointView, _gpsWrapper), Ui.SLIDE_RIGHT);
                }
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