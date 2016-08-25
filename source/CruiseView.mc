using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class CruiseView extends Ui.View 
{
	hidden var _dcDraw = new DcDraw();
    hidden var _gpsHelper;
	hidden var _timer;
	hidden var _lapCounter = 0;
	hidden var _lapArray = new [10];
	hidden var _activeSession;
	
	hidden var _isWhiteBackground = false;

    function initialize(gpsHelper) 
    {
        View.initialize();
        _gpsHelper = gpsHelper;
        _activeSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _isWhiteBackground = Application.getApp().getProperty(@Strings.BackgroundPropertyName);
        _dcDraw.SetupColors(_isWhiteBackground);
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
    	_dcDraw.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        _dcDraw.PrintTime(dc, clockTime);
        
        // Display speed and bearing if GPS available
        //
        if (_gpsHelper.Accuracy() > 0)
        {
        	// Display knots
        	//
        	var currentSpeed = _gpsHelper.SpeedKnot();
        	_dcDraw.PrintSpeed(dc, currentSpeed);
        	
        	// Display bearing
        	//
        	_dcDraw.PrintBearing(dc, _gpsHelper.BearingDegree());
        	
        	// Display max speed 
        	//
        	_dcDraw.PrintMaxSpeed(dc, _gpsHelper.MaxSpeedKnot());	
        	
        	// Display average speed for last 10 sec.
        	//
        	var avgSpeed = _gpsHelper.AvgSpeedKnotLast10();
        	_dcDraw.PrintAvgSpeed(dc, avgSpeed);
        	
        	// Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
        	//
        	_dcDraw.DisplaySpeedTrend(dc, currentSpeed - avgSpeed); 
        }
        
        _dcDraw.DisplayState(dc, _gpsHelper.Accuracy(), _activeSession.isRecording(), _lapCounter);
        
        _dcDraw.DrawGrid(dc);
    }

    // Add new lap and drop all lap counters 
    //
    function AddLap()
    {
        if (_activeSession.isRecording())
        {
            _activeSession.addLap();
        }
        
        if (_gpsHelper.Accuracy() < 2)	
        {
        	return;	
        }
        
        _lapCounter = _lapCounter + 1;
        
        var vibe = [new Attention.VibeProfile(30, 300)];
        Attention.playTone(Attention.TONE_LOUD_BEEP);        
        Attention.vibrate(vibe);        
    }    
    
    // Start & Pause activity recording
    //
    function StartStopActivity()
    {
    	if (_gpsHelper.Accuracy() < 2 && !_activeSession.isRecording())
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
    }
    
    function DiscardActivity()
    {
        if (_activeSession != null)
    	{
    		_activeSession.discard();
    	}
    }
    
    function InverseColor()
    {
    	_isWhiteBackground = !_isWhiteBackground;
    	
    	Application.getApp().setProperty(@Strings.BackgroundPropertyName, _isWhiteBackground);
    	
   		_dcDraw.SetupColors(_isWhiteBackground);
    }
}
