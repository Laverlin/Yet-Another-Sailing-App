using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;

class IBSailingCruiseView extends Ui.View 
{

	hidden var _timer;
	hidden var positionInfo;
	hidden var maxSpeed;

    function initialize() 
    {
        View.initialize();
        maxSpeed = 0.0;
    }

    // Load your resources here
    function onLayout(dc) 
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    }

    // Update the view
    function onUpdate(dc) 
    {
    	var clockTime = Sys.getClockTime();
    	
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        
        if (positionInfo != null)
        {
        	var speed = (positionInfo.speed.toDouble() * 1.94384);
        	var speedString = speed.format("%2.1f");
        	View.findDrawableById("SpeedLabel").setText(speedString);
        	
        	var bearingString = (180-Math.toDegrees(positionInfo.heading)).format("%003d");
        	View.findDrawableById("BearingLabel").setText(bearingString);
        	
        	if (maxSpeed < speed)
        	{
        		maxSpeed = speed;
        	}
        	View.findDrawableById("MaxSpeedLabel").setText(maxSpeed.format("%2.1f"));	
        }

       	View.onUpdate(dc);
        
        // Draw a grig
        //
        dc.drawLine(0,60,218,60);
		dc.drawLine(0,160,218,160);
		dc.drawLine(109,60,109,160); 
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    	_timer.stop();
    }
    
    function onTimerUpdate()
    {
    	Ui.requestUpdate();
    }
    
    function setPosition(info)
    {
    	positionInfo = info;
    }
}
