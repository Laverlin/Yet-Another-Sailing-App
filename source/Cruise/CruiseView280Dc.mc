using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class CruiseView280Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];
    hidden var halfd = 140;	
    hidden var _margin = 7;
	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	function PrintTime(dc, time)
	{
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(140, 8, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(halfd - _margin, 82, Gfx.FONT_NUMBER_HOT, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(halfd - _margin, 184, Gfx.FONT_XTINY, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(halfd + _margin, 82, Gfx.FONT_NUMBER_HOT, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(halfd + _margin, 184, Gfx.FONT_XTINY, "COG", Gfx.TEXT_JUSTIFY_LEFT);    
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(80, 170, Gfx.FONT_MEDIUM, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
     //   dc.drawText(102, 192, Gfx.FONT_XTINY, "max", Gfx.TEXT_JUSTIFY_RIGHT);       
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
        var avgSpeedString = avgSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(halfd + _margin, 246, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(halfd + _margin, 215, Gfx.FONT_LARGE, avgSpeedString, Gfx.TEXT_JUSTIFY_LEFT);     
        dc.drawText(202, 214, Gfx.FONT_XTINY, "kn", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintAvgBearing(dc, avgBearing)
    {
        var avgBearingString = avgBearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(halfd + _margin, 246, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(halfd + _margin, 215, Gfx.FONT_LARGE, avgBearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(202, 214, Gfx.FONT_XTINY, "o", Gfx.TEXT_JUSTIFY_LEFT);
    }    
    
    function PrintTotalDistance(dc, totalDistance)
    {
        var distanceString = totalDistance.format("%003.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(halfd - _margin, 246, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(halfd - _margin, 215, Gfx.FONT_LARGE, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
     }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 70, 280, 70);
		dc.drawLine(0, 215, 280, 215);
		dc.drawLine(140, 70, 140, 280);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	
    	dc.drawText(80, 43, Gfx.FONT_XTINY, Lang.format("lap: $1$",[lapCount]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(130, 43, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(190, 43, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(145, 54, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(205, 54, 8);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff)
    {
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
        	dc.fillPolygon([[130, 74], [124, 96], [136, 96]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, Settings.BackgroundColor);
        	dc.fillPolygon([[124, 74], [130, 96], [136, 74]]);
        }
    }
}