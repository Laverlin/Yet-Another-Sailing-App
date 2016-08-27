using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;
using Toybox.Time as Time;

class CruiseView extends Ui.View 
{
	hidden var _dcWrapper = new DcWrapper();
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _activeSession;
    hidden var _startTime;
	
	hidden var _isWhiteBackground = false;

    function initialize(gpsHelper) 
    {
        View.initialize();
        _gpsWrapper = gpsHelper;
        _activeSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _isWhiteBackground = Application.getApp().getProperty("isWhiteBackground");
        _dcWrapper.SetupColors(_isWhiteBackground);
        _startTime = Time.now();
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
    	_dcWrapper.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        _dcWrapper.PrintTime(dc, clockTime);
        
        // Display speed and bearing if GPS available
        //
        if (_gpsWrapper.Accuracy() > 0)
        {
        	// Display knots
        	//
        	var currentSpeed = _gpsWrapper.SpeedKnot();
        	_dcWrapper.PrintSpeed(dc, currentSpeed);
        	
        	// Display bearing
        	//
        	_dcWrapper.PrintBearing(dc, _gpsWrapper.BearingDegree());
        	
        	// Display max speed 
        	//
        	_dcWrapper.PrintMaxSpeed(dc, _gpsWrapper.MaxSpeedKnot());	
        	
        	// Display average speed for last 10 sec.
        	//
        	var avgSpeed = _gpsWrapper.AvgSpeedKnotLast10();
        	_dcWrapper.PrintAvgSpeed(dc, avgSpeed);
        	
        	// Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
        	//
        	_dcWrapper.DisplaySpeedTrend(dc, currentSpeed - avgSpeed); 

            _gpsWrapper.UpdateLapData();
        }
        
        _dcWrapper.DisplayState(dc, _gpsWrapper.Accuracy(), _activeSession.isRecording(), _gpsWrapper.GetLapCount());
        
        _dcWrapper.DrawGrid(dc);
    }

    // Add new lap and drop all lap counters 
    //
    function AddLap()
    {
        if (_activeSession.isRecording())
        {
            _activeSession.addLap();
        }
        
        if (_gpsWrapper.Accuracy() < 2)	
        {
        	return;	
        }
        
        var vibe = [new Attention.VibeProfile(30, 300)];
        Attention.playTone(Attention.TONE_LOUD_BEEP);        
        Attention.vibrate(vibe);        

        _gpsWrapper.AddLap();        
    }    
    
    // Start & Pause activity recording
    //
    function StartStopActivity()
    {
    	if (_gpsWrapper.Accuracy() < 2 && !_activeSession.isRecording())
    	{
    		return;
    	}
    	
    	var vibe = [new Attention.VibeProfile(30, 300)];
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(vibe);
    	
    	if (!_activeSession.isRecording())
    	{
    		_activeSession.start();
    	}
    	else
    	{
    		_activeSession.stop();
    	}
    }

    function SaveActivity()
    {
    	if (_activeSession != null)
    	{
    		_activeSession.save();
    	}
        _gpsWrapper.LogAppStatistic(_startTime, Time.now());
    }
    
    function DiscardActivity()
    {
        if (_activeSession != null)
    	{
    		_activeSession.discard();
    	}
        _gpsWrapper.LogAppStatistic(_startTime, Time.now());
    }
    
    function InverseColor()
    {
    	_isWhiteBackground = !_isWhiteBackground;
    	
    	Application.getApp().setProperty("isWhiteBackground", _isWhiteBackground);
    	
   		_dcWrapper.SetupColors(_isWhiteBackground);
    }
}
