using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class CruiseView454Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];
    hidden var _digitFont = Ui.loadResource(Rez.Fonts.digits);

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
        dc.drawText(220, 130, _digitFont, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(217, 270, Gfx.FONT_TINY, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(236, 130, _digitFont, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(425, 270, Gfx.FONT_TINY, "COG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(110, 258, Gfx.FONT_MEDIUM, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
        var avgSpeedString = avgSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(265, 337, Gfx.FONT_LARGE, avgSpeedString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(305, 390, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	     
        dc.drawText(270 + dc.getTextWidthInPixels(avgSpeedString, Gfx.FONT_LARGE), 330, Gfx.FONT_XTINY, "kn", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintAvgBearing(dc, avgBearing)
    {
        var avgBearingString = avgBearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(265, 337, Gfx.FONT_LARGE, avgBearingString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(305, 390, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(270 + dc.getTextWidthInPixels(avgBearingString, Gfx.FONT_LARGE), 330, Gfx.FONT_XTINY, "o", Gfx.TEXT_JUSTIFY_LEFT);
    }    
    
    function PrintTotalDistance(dc, totalDistance)
    {
        var distanceString = totalDistance.format("%003.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(200, 337, Gfx.FONT_LARGE, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(200, 390, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
     }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 140, 454, 140);
		dc.drawLine(0, 315, 454, 315);
		dc.drawLine(227, 140, 227, 315);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.drawText(123, 96, Gfx.FONT_XTINY, lapCount, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
    	dc.drawText(115, 95, Gfx.FONT_XTINY, "lap:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(280, 95, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(360, 95, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(295, 116, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(375, 116, 8);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff, speed)
    {
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
        	dc.fillPolygon([[144, 150], [138, 180], [150, 180]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, Settings.BackgroundColor);
        	dc.fillPolygon([[138, 150], [144, 180], [150, 150]]);
        }
    }
}