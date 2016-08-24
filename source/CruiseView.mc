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
	hidden var _positionInfo;

	hidden var _activeSession;
	hidden var _isWhiteBackground = false;

    function initialize(gpsHelper) 
    {
        View.initialize();
        _gpsHelper = gpsHelper;
        _activeSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _isWhiteBackground = Application.getApp().getProperty("isWhiteBackground");
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
    
    	var clockTime = Sys.getClockTime();
    	
    	// Display current time
    	//
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        _dcDraw.PrintTime(dc, timeString);
        
        // Display speed and bearing if GPS available
        //
        if (_gpsHelper.Accuracy() > 0)
        {
        	// Display knots
        	//
        	var speedString = _gpsHelper.SpeedKnot().format("%2.1f");
        	_dcDraw.PrintSpeed(dc, speedString);
        	
        	// Display bearing
        	//
        	_dcDraw.PrintBearing(dc, _gpsHelper.BearingDegree().format("%003d"));
        	
        	// Display max speed 
        	//
        	_dcDraw.PrintMaxSpeed(dc, _gpsHelper.MaxSpeedKnot().format("%2.1f"));	
        	
        	// Display average speed for last 10 sec.
        	//
        	_dcDraw.PrintAvgSpeed(dc, _gpsHelper.AvgSpeedKnotLast10().format("%2.1f"));
        }
        
        _dcDraw.DisplayState(dc, _gpsHelper.Accuracy(), _activeSession.isRecording());
        
        _dcDraw.DrawGrid(dc);
    }

    // Add new lap and drop all lap counters 
    //
    function AddLap()
    {
        if (_activeSession.isRecording())
        {
            var vibe = [new Attention.VibeProfile(30, 300)];
            Attention.playTone(Attention.TONE_LOUD_BEEP);        
            Attention.vibrate(vibe);
           
            _activeSession.addLap();
        }
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
    	
    	Application.getApp().setProperty("isWhiteBackground", _isWhiteBackground);
    	
   		_dcDraw.SetupColors(_isWhiteBackground);
    }
}
