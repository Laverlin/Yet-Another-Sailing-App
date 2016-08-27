using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;

class LapView extends Ui.View 
{
    hidden var _laps;
    hidden var _currentLapNum = 0;


	function initialize(laps) 
    {
        View.initialize();
        
        _laps = laps;
        _currentLap = 0;

    }

    function onShow() 
    {

    }

    function onHide() 
    {

    }

    function onUpdate(dc) 
    {   
    	//var currentLap = _gpsWrapper.GetLap(_currentLapNum);
    	
    	//dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(109, 12, Gfx.FONT_LARGE, "lap :: " + _currentLapNum.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 30, Gfx.FONT_LARGE, "max speed : " + laps[_currentLapNum].MaxSpeed.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 50, Gfx.FONT_LARGE, "avg speed : " + laps[_currentLapNum].AvgSpeed.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 70, Gfx.FONT_LARGE, "distance : " + laps[_currentLapNum].Distance.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 90, Gfx.FONT_LARGE, "lap time : " + laps[_currentLapNum].LapTime.toString(), Gfx.TEXT_JUSTIFY_CENTER);
    }
}