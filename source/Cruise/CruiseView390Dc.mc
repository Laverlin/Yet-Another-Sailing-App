using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class CruiseView390Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];

	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	function PrintTime(dc, time)
	{
        var center = dc.getWidth() / 2;
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(center, 32, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(185, 130, Gfx.FONT_NUMBER_HOT, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(185, 255, Gfx.FONT_TINY, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(205, 130, Gfx.FONT_NUMBER_HOT, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(365, 255, Gfx.FONT_TINY, "COG", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(95, 243, Gfx.FONT_MEDIUM, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
        var avgSpeedString = avgSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(205, 302, Gfx.FONT_LARGE, avgSpeedString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(205, 350, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	     
        dc.drawText(205 + dc.getTextWidthInPixels(avgSpeedString, Gfx.FONT_LARGE), 300, Gfx.FONT_XTINY, "kn", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintAvgBearing(dc, avgBearing)
    {
        var avgBearingString = avgBearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(205, 302, Gfx.FONT_LARGE, avgBearingString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(205, 350, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(205 + dc.getTextWidthInPixels(avgBearingString, Gfx.FONT_LARGE), 295, Gfx.FONT_XTINY, "o", Gfx.TEXT_JUSTIFY_LEFT);
    }    
    
    function PrintTotalDistance(dc, totalDistance)
    {
        var distanceString = totalDistance.format("%003.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(185, 302, Gfx.FONT_LARGE, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(185, 350, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
     }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 125, 390, 125);
		dc.drawLine(0, 300, 390, 300);
		dc.drawLine(195, 125, 195, 300);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.drawText(123, 91, Gfx.FONT_XTINY, lapCount, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
    	dc.drawText(115, 90, Gfx.FONT_XTINY, "lap:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(250, 90, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(330, 90, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(265, 108, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(345, 108, 8);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff, speed)
    {
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
        	dc.fillPolygon([[121, 135], [115, 165], [127, 165]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, Settings.BackgroundColor);
        	dc.fillPolygon([[115, 135], [121, 165], [127, 135]]);
        }
    }
}