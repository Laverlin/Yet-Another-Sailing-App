using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class IBSailingCruiseView extends Ui.View 
{

	hidden var _drawObjects = new DrawObjects();
	hidden var _timer;
	hidden var _positionInfo;
	hidden var _maxSpeed;
	hidden var _recordSession;
	hidden var _isInversed = false;
	hidden var _gpsStatus = 0;
	
	hidden var _speedSum = 0.0;
	hidden var _speedCount = 0;

    function initialize() 
    {
        View.initialize();
        _recordSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _maxSpeed = 0.0;
    }

    // SetUp timer on show
    //
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    }

    // Update the view
    //
    function onUpdate(dc) 
    {   
    	_drawObjects.SetBackground(dc);
    
    	var clockTime = Sys.getClockTime();
    	
    	// Display current time
    	//
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        _drawObjects.PrintTime(dc, timeString);
        
        // Display speed and bearing if GPS available
        //
        if (_positionInfo != null && _positionInfo.accuracy > 0)
        {
        	_gpsStatus = _positionInfo.accuracy;
        
        	// Display knots
        	//
        	var speed = (_positionInfo.speed.toDouble() * 1.94384);
        	var speedString = speed.format("%2.1f");
        	_drawObjects.PrintSpeed(dc, speedString);
        	
        	// Display bearing
        	//
        	var headingDegree = Math.toDegrees(_positionInfo.heading);
        	var bearingString = ((headingDegree > 0) ? headingDegree : 360 + headingDegree).format("%003d");
        	_drawObjects.PrintBearing(dc, bearingString);
        	
        	// Display max speed 
        	//
        	_maxSpeed = (_maxSpeed < speed) ? speed : _maxSpeed;
        	_drawObjects.PrintMaxSpeed(dc, _maxSpeed.format("%2.1f"));	
        	
        	// Display average speed if recorded
        	//
        	if (_recordSession.isRecording())
        	{
        		_speedCount = _speedCount + 1;
        		_speedSum = _speedSum + speed;
        		var avgSpeed = _speedSum / _speedCount;
        		_drawObjects.PrintAvgSpeed(dc, avgSpeed.format("%2.1f"));  
        	}      	
        }
        
        _drawObjects.DisplayStatuses(dc, _gpsStatus, _recordSession.isRecording());
        
        _drawObjects.DrawGrid(dc);
 
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
    
    // update position from GPS
    //
    function setPosition(info)
    {
    	_positionInfo = info;
    }
    
    // Start & Pause activity recording
    //
    function StartStopActivity()
    {
    	if (_gpsStatus < 2 && !_recordSession.isRecording())
    	{
    		return;
    	}
    	
    	var vibe = [new Attention.VibeProfile(30, 300)];
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(vibe);
    	
    	if (!_recordSession.isRecording())
    	{
    		_recordSession.start();
    	}
    	else
    	{
    		_speedSum = 0.0;
    		_speedCount = 0;
    		_recordSession.stop();
    	}
    }
    
    // Save activity session
    //
    function SaveActivity()
    {
    	if (_recordSession != null)
    	{
    		_recordSession.save();
    	}
    }
    
    function DiscardActivity()
    {
        if (_recordSession != null)
    	{
    		_recordSession.discard();
    	}
    }
    
    function InverseLayout()
    {
    	_isInversed = !_isInversed;
    	if (_isInversed)
    	{
    		_drawObjects.SetColors(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	}
    	else
    	{
    		_drawObjects.SetColors(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	}
    	
    }
}
