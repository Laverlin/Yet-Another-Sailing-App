using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class IBSailingCruiseView extends Ui.View 
{

	hidden var _timer;
	hidden var _positionInfo;
	hidden var _maxSpeed;
	hidden var _recordSession;
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];
	hidden var _isGpsAvailable = false;
	
	hidden var _speedSum = 0.0;
	hidden var _speedCount = 0;

    function initialize() 
    {
        View.initialize();
        _recordSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _maxSpeed = 0.0;
    }

    // Load your resources here
    //
    function onLayout(dc) 
    {
        setLayout(Rez.Layouts.MainLayout(dc));
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
    	var clockTime = Sys.getClockTime();
    	
    	// Display current time
    	//
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        View.findDrawableById("TimeLabel").setText(timeString);
        
        // Display speed and bearing if GPS available
        //
        var gpsStateColor = Gfx.COLOR_RED;
        if (_positionInfo != null && _positionInfo.accuracy > 0)
        {
        	gpsStateColor = _gpsColorsArray[_positionInfo.accuracy];
        	_isGpsAvailable = (_positionInfo.accuracy > 2) ? true : false;
        
        	// Display knots
        	//
        	var speed = (_positionInfo.speed.toDouble() * 1.94384);
        	var speedString = speed.format("%2.1f");
        	View.findDrawableById("SpeedLabel").setText(speedString);
        	
        	// Display bearing
        	//
        	var headingDegree = Math.toDegrees(_positionInfo.heading);
        	var bearingString = ((headingDegree > 0) ? headingDegree : 360 + headingDegree).format("%003d");
        	View.findDrawableById("BearingLabel").setText(bearingString);
        	
        	// Display max speed 
        	//
        	_maxSpeed = (_maxSpeed < speed) ? speed : _maxSpeed;
        	View.findDrawableById("MaxSpeedLabel").setText(_maxSpeed.format("%2.1f"));	
        	
        	// Display average speed if recorded
        	//
        	if (_recordSession.isRecording())
        	{
        		_speedCount = _speedCount + 1;
        		_speedSum = _speedSum + speed;
        		var avgSpeed = _speedSum / _speedCount;
        		View.findDrawableById("AvgSpeedLabel").setText(avgSpeed.format("%2.1f"));  
        	}      	
        }

       	View.onUpdate(dc);
        
        // Show GPS quality
        //
        dc.setColor(gpsStateColor, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 48, 6);
        
        // Show recording status
        //
        dc.setColor(_recordSession.isRecording() ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 172, 6);
        
        // Draw a grid
        //
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(0,60,218,60);
		dc.drawLine(0,160,218,160);
		dc.drawLine(109,60,109,160); 
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
    	if (!_isGpsAvailable && !_recordSession.isRecording())
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
}
