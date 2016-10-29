using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CruiseView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _isAvgSpeedDisplay = true;
	hidden var _displayMode = 0;

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
    	CruiseViewDc.ClearDc(dc);
    
    	// Display current time
    	//
        var clockTime = Sys.getClockTime();        
        CruiseViewDc.PrintTime(dc, clockTime);
        
        // Display speed and bearing if GPS available
        //
        var gpsInfo = _gpsWrapper.GetGpsInfo();
        if (gpsInfo.Accuracy > 0)
        {
        	CruiseViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
        	CruiseViewDc.PrintBearing(dc, gpsInfo.BearingDegree);
        	CruiseViewDc.PrintMaxSpeed(dc, gpsInfo.MaxSpeedKnot);	
        	CruiseViewDc.PrintTotalDistance(dc, gpsInfo.TotalDistance);
        	
        	if (_displayMode == 0)
        	{
        		CruiseViewDc.PrintAvgBearing(dc, gpsInfo.AvgBearingDegree);
        	} 
        	else if (_displayMode == 1)
        	{
        		CruiseViewDc.PrintAvgSpeed(dc, gpsInfo.AvgSpeedKnot);
        	} 

        	// Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
        	//
        	CruiseViewDc.DisplaySpeedTrend(dc, gpsInfo.SpeedKnot - gpsInfo.AvgSpeedKnot); 
        }
        
        CruiseViewDc.DisplayState(dc, gpsInfo.Accuracy, gpsInfo.IsRecording, gpsInfo.LapCount);
        
        CruiseViewDc.DrawGrid(dc);
    }
    
    function SwitchNextMode()
    {
    	_displayMode += 1;
    	_displayMode = _displayMode % 2;
    }
}