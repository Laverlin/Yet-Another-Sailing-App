using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class DrawObjects
{
	hidden var _backgroundColor = Gfx.COLOR_BLACK;
	hidden var _foregroundColor = Gfx.COLOR_WHITE;
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	

	function SetBackground(dc)
	{
    	dc.setColor(_foregroundColor, _backgroundColor);
    	dc.clear();
    }
    
    function SetColors(foreground, background)
    {
    	_foregroundColor = foreground;
    	_backgroundColor = background;
    }

	function PrintTime(dc, timeString)
	{
		dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(109, 15, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speedString)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(90, 60, Gfx.FONT_NUMBER_HOT, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(102, 134, Gfx.FONT_XTINY, "knot", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearingString)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(200, 60, Gfx.FONT_NUMBER_HOT, bearingString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(208, 134, Gfx.FONT_XTINY, "bearing", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintMaxSpeed(dc, maxSpeedString)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(94, 162, Gfx.FONT_LARGE, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(102, 192, Gfx.FONT_XTINY, "max", Gfx.TEXT_JUSTIFY_RIGHT);       
    }
    
    function PrintAvgSpeed(dc, avgSpeedString)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(168, 162, Gfx.FONT_LARGE, avgSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(154, 192, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawLine(0,60,218,60);
		dc.drawLine(0,160,218,160);
		dc.drawLine(109,60,109,160);
    }
    
    function DisplayStatuses(dc, gpsStatus, recordingStatus)
    {
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 48, 6);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 172, 6);
    }
}