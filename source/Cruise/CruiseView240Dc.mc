using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class CruiseView240Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	
	hidden var _width;
	hidden var _height;

	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    	_width = dc.getWidth();
	    _height = dc.getHeight();
    }

	function PrintTime(dc, time)
	{
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth() / 2, 7, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
    	var y =  _height / 2 - dc.getFontHeight(Gfx.FONT_NUMBER_HOT) / 2 - dc.getFontHeight(Gfx.FONT_MEDIUM) / 4 - 2;
    
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(_width / 4, y, Gfx.FONT_NUMBER_HOT, speedString, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);
        	        
        dc.drawText(
        	_width / 2 - 4, 
        	_height - _height / 3.5 - dc.getFontHeight(Gfx.FONT_TINY), 
        	(dc.getFontHeight(Gfx.FONT_NUMBER_HOT) == 52) ? Gfx.FONT_XTINY : Gfx.FONT_TINY, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
    	var y =  _height / 2 - dc.getFontHeight(Gfx.FONT_NUMBER_HOT) / 2 - dc.getFontHeight(Gfx.FONT_MEDIUM) / 4 - 2;
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(
        	_width / 2 + _width / 4, 
        	y, Gfx.FONT_NUMBER_HOT, bearingString, Gfx.TEXT_JUSTIFY_CENTER);
        	
        dc.setColor(Settings.DimColor, Settings.BackgroundColor);	
        dc.drawText(
        	_width - 16, 
        	_height - _height / 3.5 - dc.getFontHeight(Gfx.FONT_TINY), 
        	(dc.getFontHeight(Gfx.FONT_NUMBER_HOT) == 52) ? Gfx.FONT_XTINY : Gfx.FONT_TINY, "COG", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintMaxSpeed(dc, maxSpeed)
    {
        var maxSpeedString = maxSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(20, _height - _height / 3.5 - dc.getFontHeight(Gfx.FONT_MEDIUM), Gfx.FONT_MEDIUM, maxSpeedString, Gfx.TEXT_JUSTIFY_LEFT);
     //   dc.drawText(102, 192, Gfx.FONT_XTINY, "max", Gfx.TEXT_JUSTIFY_RIGHT);       
    }
    
    function PrintAvgSpeed(dc, avgSpeed)
    {
    	var bottomLine = _height - (_height / 3.5).toNumber();
    	
        var avgSpeedString = avgSpeed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(_width / 2 + 10,  bottomLine, Gfx.FONT_LARGE, avgSpeedString, Gfx.TEXT_JUSTIFY_LEFT);  
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(_width / 2 + 10, bottomLine + dc.getFontHeight(Gfx.FONT_LARGE) - 6, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   
        dc.drawText(_width / 2 + 10 + dc.getTextWidthInPixels(avgSpeedString, Gfx.FONT_LARGE), bottomLine, Gfx.FONT_XTINY, "kn", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintAvgBearing(dc, avgBearing)
    {
    	var bottomLine = _height - (_height / 3.5).toNumber();
    	
        var avgBearingString = avgBearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(_width / 2 + 10, bottomLine, Gfx.FONT_LARGE, avgBearingString, Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(_width / 2 + 10, bottomLine + dc.getFontHeight(Gfx.FONT_LARGE) - 6, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_LEFT);   	
        dc.drawText(_width / 2 + 10 + dc.getTextWidthInPixels(avgBearingString, Gfx.FONT_LARGE), bottomLine, Gfx.FONT_XTINY, "o", Gfx.TEXT_JUSTIFY_LEFT);
    }    
    
    function PrintTotalDistance(dc, totalDistance)
    {
    	var bottomLine = _height - (_height / 3.5).toNumber();
        var distanceString = totalDistance.format("%003.1f");
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(_width / 2 - 10, bottomLine + dc.getFontHeight(Gfx.FONT_LARGE) - 6, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(_width / 2 - 10, bottomLine, Gfx.FONT_LARGE, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
     }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	var margin = (_height / 3.5).toNumber();
        dc.drawLine(0, margin, _width, margin);
		dc.drawLine(0, _height - margin, _width, _height - margin);
		dc.drawLine(_width / 2, margin, _width / 2, _height - margin);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	var margin = (_height / 3.5).toNumber();
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	
    	//Toybox.System.println(dc.getFontHeight(Gfx.FONT_XTINY));
    	var ty = dc.getFontHeight(Gfx.FONT_XTINY) == 19 
    		? (margin - dc.getFontHeight(Gfx.FONT_XTINY) * 3 / 2)
    		: margin - dc.getFontHeight(Gfx.FONT_XTINY) - 3;
    		
    	dc.drawText(80, ty, Gfx.FONT_XTINY, Lang.format("lap: $1$",[lapCount]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(130, ty, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(190, ty, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(142, ty + dc.getFontHeight(Gfx.FONT_XTINY) / 2 + 2, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(202, ty + dc.getFontHeight(Gfx.FONT_XTINY) / 2 + 2, 8);
    }
    
    // Display speed gradient. If current speed > avg speed then trend is positive and vice versa.
    //
    function DisplaySpeedTrend(dc, speedDiff, speed)
    {
    	var yTop = (_height / 3.5).toNumber() + 4;
    	var height = (dc.getFontHeight(Gfx.FONT_NUMBER_HOT) == 52) ? 15 : 20;
    	
    	var xDot = _width / 4 - 
    			dc.getTextWidthInPixels(speed.format("%2.1f"), Gfx.FONT_NUMBER_HOT) / 2 +
    			dc.getTextWidthInPixels(speed.toNumber().toString(), Gfx.FONT_NUMBER_HOT) + 
    			dc.getTextWidthInPixels(".", Gfx.FONT_NUMBER_HOT) / 2;
    		   	
    	if (speedDiff > 0)
        {
        	dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
        	dc.fillPolygon([[xDot, yTop], [xDot - 6, yTop + height], [xDot + 6, yTop + height]]);
        }
        
        if (speedDiff < 0)
        {
        	dc.setColor(Gfx.COLOR_RED, Settings.BackgroundColor);
        	dc.fillPolygon([[xDot - 6, yTop], [xDot, yTop + height], [xDot + 6, yTop]]);
        }
    }
}