using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Graphics as Gfx;

class LapView extends Ui.View 
{
    hidden var _laps;
    hidden var _gpsWrapper;
    hidden var _currentLapNum = 0;
    


	function initialize(gpsWrapper) 
    {
        View.initialize();
        
        _gpsWrapper = gpsWrapper;
        _currentLapNum = 0;

    }

    function onShow() 
    {

    }

    function onHide() 
    {

    }

    function onUpdate(dc) 
    {   
    	var currentLap = _gpsWrapper.GetLap(_currentLapNum);
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.clear();
    	
        dc.drawText(109, 12, Gfx.FONT_MEDIUM, "lap :: " + _currentLapNum.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 50, Gfx.FONT_MEDIUM, "max speed : " + currentLap.MaxSpeed.format("%2.1f"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 80, Gfx.FONT_MEDIUM, "avg speed : " + currentLap.AvgSpeed.format("%2.1f"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 110, Gfx.FONT_MEDIUM, "distance : " + currentLap.Distance.format("%2d"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 140, Gfx.FONT_MEDIUM, "lap time : " + currentLap.LapTime.toString(), Gfx.TEXT_JUSTIFY_CENTER);
    }
}