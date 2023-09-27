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
    hidden var _fontBigDigits = Ui.loadResource(Rez.Fonts.bigDigits);
    hidden var _fontText = Ui.loadResource(Rez.Fonts.text);
    hidden var _fontMidDigits = Ui.loadResource(Rez.Fonts.midDigits);
    hidden var _fontHint = Ui.loadResource(Rez.Fonts.hint);

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
        dc.drawText(center, 26, _fontText, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(220, 130, _fontBigDigits, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(217, 256, _fontText, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(236, 130, _fontBigDigits, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(425, 256, _fontText, "COG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(125, 247, _fontMidDigits, maxSpeedString, Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
        var avgSpeedString = avgSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(265, 330, _fontMidDigits, avgSpeedString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(265, 390, _fontHint, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	     
        dc.drawText(270 + dc.getTextWidthInPixels(avgSpeedString, _fontMidDigits), 330, _fontHint, "kn", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintAvgBearing(dc, avgBearing)
    {
        var avgBearingString = avgBearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(265, 330, _fontMidDigits, avgBearingString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(265, 390, _fontHint, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(270 + dc.getTextWidthInPixels(avgBearingString, _fontMidDigits), 330, _fontHint, "o", Gfx.TEXT_JUSTIFY_LEFT);
    }    
    
    function PrintTotalDistance(dc, totalDistance)
    {
        var distanceString = totalDistance.format("%003.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(200, 330, _fontMidDigits, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        dc.drawText(200, 390, _fontHint, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
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
    	dc.drawText(123, 96, _fontHint, lapCount, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
    	dc.drawText(115, 95, _fontHint, "lap:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(280, 95, _fontHint, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(370, 95, _fontHint, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(290, 116, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(380, 116, 8);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff, speed)
    {
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
        	dc.fillPolygon([[146, 150], [140, 180], [152, 180]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, Settings.BackgroundColor);
        	dc.fillPolygon([[140, 150], [146, 180], [152, 150]]);
        }
    }
}