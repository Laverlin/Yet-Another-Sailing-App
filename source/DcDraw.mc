using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

/// Since there is no way o setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class DcDraw
{
	hidden var _backgroundColor = Gfx.COLOR_BLACK;
	hidden var _foregroundColor = Gfx.COLOR_WHITE;
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	

	function ClearDc(dc)
	{
    	dc.setColor(_foregroundColor, _backgroundColor);
    	dc.clear();
    }
    
    function SetupColors(isWhiteBackground)
    {
    	if (isWhiteBackground)
    	{
    		_foregroundColor = Gfx.COLOR_BLACK;
    		_backgroundColor = Gfx.COLOR_WHITE;
    	}
    	else
    	{
    		_foregroundColor = Gfx.COLOR_WHITE;
    		_backgroundColor = Gfx.COLOR_BLACK;    	
    	}
    }

	function PrintTime(dc, time)
	{
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(109, 12, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(90, 60, Gfx.FONT_NUMBER_HOT, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(102, 134, Gfx.FONT_XTINY, "knot", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(200, 60, Gfx.FONT_NUMBER_HOT, bearingString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(208, 134, Gfx.FONT_XTINY, "bearing", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(_foregroundColor, _backgroundColor);
        dc.drawText(94, 162, Gfx.FONT_LARGE, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(102, 192, Gfx.FONT_XTINY, "max", Gfx.TEXT_JUSTIFY_RIGHT);       
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
        var avgSpeedString = avgSpeed.format("%2.1f");
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
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	dc.setColor(_foregroundColor, _backgroundColor);
    	
    	dc.drawText(60, 38, Gfx.FONT_XTINY, Lang.format("lap: $1$",[lapCount]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(110, 38, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(170, 38, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(120, 48, 6);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 48, 6);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff)
    {
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, _backgroundColor);
        	dc.fillPolygon([[100, 64], [94, 86], [106, 86]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, _backgroundColor);
        	dc.fillPolygon([[94, 64], [100, 86], [106, 64]]);
        }
    }
}