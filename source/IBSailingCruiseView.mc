using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;

class IBSailingCruiseView extends Ui.View 
{

	hidden var _timer;
	hidden var _positionInfo;
	hidden var _maxSpeed;

    function initialize() 
    {
        View.initialize();
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
    	
    	// show current time
    	//
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        
        // Show speed and bearing if GPS available
        //
        var GpsStateColor = Gfx.COLOR_RED;
        if (_positionInfo != null)
        {
        	if (_positionInfo.accuracy == 2)
        	{
        		GpsStateColor = Gfx.COLOR_ORANGE;
        	}
        	
        	if (_positionInfo.accuracy == 3)
        	{
        		GpsStateColor = Gfx.COLOR_YELLOW;
        	}
        	
        	if (_positionInfo.accuracy == 4)
        	{
        		GpsStateColor = Gfx.COLOR_GREEN;
        	}
        
        	var speed = (_positionInfo.speed.toDouble() * 1.94384);
        	var speedString = speed.format("%2.1f");
        	View.findDrawableById("SpeedLabel").setText(speedString);
        	
        	var headingDegree = Math.toDegrees(_positionInfo.heading);
        	var bearingString = ((headingDegree > 0) ? headingDegree : 360 + headingDegree).format("%003d");
        	View.findDrawableById("BearingLabel").setText(bearingString);
        	
        	if (_maxSpeed < speed)
        	{
        		_maxSpeed = speed;
        	}
        	View.findDrawableById("MaxSpeedLabel").setText(_maxSpeed.format("%2.1f"));	
        }

       	View.onUpdate(dc);
        
        // Show GPS quality
        //
        dc.setColor(GpsStateColor, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(182, 50, 4);
        
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
}
